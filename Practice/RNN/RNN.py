import theano
import numpy as np
import os, time

from theano import tensor as T
from collections import OrderedDict


def contextwin(l, win):
    '''
    win :: int corresponding to the size of the window
    given a list of indexes composing a sentence
    it will return a list of list of indexes corresponding
    to context windows surrounding each word in the sentence
    '''
    assert (win % 2) == 1
    assert win >=1
    l = list(l)

    lpadded = win/2 * [-1] + l + win/2 * [-1]
    out = [ lpadded[i:i+win] for i in range(len(l)) ]

    assert len(out) == len(l)
    return np.array(out, dtype = 'int32')


class RNN(object):
    
    def __init__(self, nh = -1, nc = -1, df = -1, weights = None):
        '''
        nh :: dimension of the hidden layer
        nc :: number of classes
        df :: dimension of features
        weights :: a dict of initial weights
        '''
        if weights is None:
            # parameters of the model
            self.Wx  = theano.shared(0.2 * np.random.uniform(-1.0, 1.0, (df, nh)).astype(theano.config.floatX))
            self.Wh  = theano.shared(0.2 * np.random.uniform(-1.0, 1.0, (nh, nh)).astype(theano.config.floatX))
            self.W   = theano.shared(0.2 * np.random.uniform(-1.0, 1.0, (nh, nc)).astype(theano.config.floatX))
            self.bh  = theano.shared(np.zeros(nh, dtype=theano.config.floatX))
            self.b   = theano.shared(np.zeros(nc, dtype=theano.config.floatX))
            self.h0  = theano.shared(np.zeros(nh, dtype=theano.config.floatX))
        else:
            df, nh = weights['Wx'].shape
            nc = weights['W'].shape[1]
            assert weights['Wh'].shape == (nh, nh)
            assert weights['W'].shape == (nh, nc)
            assert weights['bh'].shape == (nh,)
            assert weights['b'].shape == (nc,)
            assert weights['h0'].shape == (nh,)
            self.Wx  = theano.shared(weights['Wx'].astype(theano.config.floatX))
            self.Wh  = theano.shared(weights['Wh'].astype(theano.config.floatX))
            self.W   = theano.shared(weights['W'].astype(theano.config.floatX))
            self.bh  = theano.shared(weights['bh'].astype(theano.config.floatX))
            self.b   = theano.shared(weights['b'].astype(theano.config.floatX))
            self.h0  = theano.shared(weights['h0'].astype(theano.config.floatX))            

        # bundle
        self.params = [self.Wx, self.Wh, self.W, self.bh, self.b, self.h0 ]
        self.names  = ['Wx', 'Wh', 'W', 'bh', 'b', 'h0']
        x = T.matrix() # win_size X number of words in a sentence 
        y = T.ivector('y')

        
        def recurrence(x_t, h_tm1):
            h_t = T.nnet.sigmoid(T.dot(x_t, self.Wx) + T.dot(h_tm1, self.Wh) + self.bh)
            s_t = T.nnet.softmax(T.dot(h_t, self.W) + self.b)
            return [h_t, s_t]

        [h, s], _ = theano.scan(fn=recurrence, sequences=x, outputs_info=[self.h0, None], n_steps=x.shape[0])

        p_y_given_x_sentence = s[:,0,:]
        y_pred = T.argmax(p_y_given_x_sentence, axis=1)

        # learning rate
        lr = T.scalar('lr')
        # loss 
        loss = -T.mean(T.log(p_y_given_x_sentence)[T.arange(x.shape[0]), y])
        gradients = T.grad( loss, self.params )
        updates = OrderedDict(( p, p-lr*g ) for p, g in zip( self.params , gradients))
        
        # theano functions
        self.predict = theano.function(inputs=[x], outputs=y_pred)

        self.bp = theano.function( inputs  = [x, y, lr],
                                      outputs = loss,
                                      updates = updates)

    def train(self, X, Y, nepochs, lr, lr_decay, win_size, w2v, verbose = True, X_test = None, Y_test = None, nlabel = 9, early_stop = 1.e-4, over_nstep = 2): 
        '''
            X, Y: training data, where X is a list of indices of words (indices indicating row-number in w2v array): 
                Y is a list of  list of 0-N indicating the N labels
            nechops: number of scans over the whole training data
            lr, lr_decay: learning rate, and learning rate decay
            win_size: construct of feature with win_size//2 neighbors
            w2v: word2vec features look-up array with each row corresponding to a word
            X_test, Y_test:  testing data for estimating performance (F1 score) for each epoch for early stop
            nlabel: number of classes in Y
            early_stop:  error toloerence for early stop using test data
            over_nstep:  compared the last epoch to previous `over_nstep` epoch
        '''
        assert len(X) == len(Y)
        if (X_test is not None) and (Y_test is not None):
            oF1 = [] # overall F1 score
        else:
             oF1 = None

        tic = time.time()
        for e in xrange(nepochs):
            XY = zip(X,Y)
            np.random.shuffle(XY)
            # X, Y = zip(*XY)
            tic0 = time.time()
            for i in xrange(len(XY)):
                self.bp(XY[i][0], XY[i][1], lr)

            lr = lr*lr_decay
            if (X_test is not None) and (Y_test is not None):
                assert len(X_test) == len(Y_test)
                pred = []
                for i in xrange(len(X_test)):
                    pred.append(self.predict(X_test[i]))

                pred = np.array([b for a in pred for b in a])
                obs = np.array([b for a in Y_test for b in a])
                recall = np.array([(obs[obs == t] == pred[obs==t]).astype('float').sum()/(obs==t).astype('float').sum() for t in xrange(N_Y)])
                recall[np.isinf(recall)] = 1
                precision = np.array([(pred[pred == t] == obs[pred==t]).astype('float').sum()/(pred==t).astype('float').sum() for t in xrange(N_Y)])
                precision[np.isinf(precision)] = 1
                F1 = 2.*recall*precision / (recall+precision)
                oF1.append(F1[~np.isnan(F1)].mean())
                if over_nstep <= e and (oF1[-1] - np.array(oF1[(e-nstep-1):e]).mean()) < early_stop:
                    break

            if verbose:
                   print 'Epoch ', e, ': training time = ', time.time() - tic0


        print 'Total training time: ', time.time() - tic
        return oF1


    def save(self, folder):   
        for param, name in zip(self.params, self.names):
            np.save(os.path.join(folder, name + '.npy'), param.get_value())

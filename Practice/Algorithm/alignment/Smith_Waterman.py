import numpy as np

## Smith–Waterman algorithm

class Smith_Waterman:
    """Smith Waterman for string alignment
    Attributes:
        a: sequence to be aligned
        b: reference sequence
        m, ms: match score, mis-match penalty
        Wi, Wd: penalty for insertion, deletion
        Go: penalty to open a gap
        H: alignment score, row = a, column = b
        T: alignment direction
        start: start position of first pair
        path: forward alignment path. 1 = match/mis-match, 2 = deletion, 3 = insertion
        aligned_string: a tuple of 2, aligned a and b
    """
    start = (0, 0)
    path = []
    aligned_string = ("", "")
    def __init__(self, a, b, m = 2, ms = -1, Wi = -1, Wd = -1, Go = -3):
        """ Initialization:
        Args:
            a: sequence to be aligned
            b: reference sequence
            m, ms: match score, mis-match penalty
            Wi, Wd: penalty for insertion, deletion
            Go: penalty to open a gap
        """
        self.a = a
        self.b = b
        self.H = np.zeros((len(a)+1, len(b)+1))
        self.T = np.zeros(self.H.shape, dtype='int8')
        self.m = m
        self.ms = ms
        self.Wi = Wi
        self.Wd = Wd
        self.Go = Go
    def _align_next(self, i, j):
        """Align the next pair
            compute the (i, j) cell of the score matrix H and direction matrix T
        Args:
            i: i-th character of a (sequence to be aligned)
            j: j-th character of b (reference sequence)
        """
        if i == 0 or j == 0:
            self.H[i,j] = 0
            self.T[i,j] = 0
            return None
        score = [0, 0, 0] # diag, left, up
        # miss match, (i-1, j-1)
        if self.a[i-1] == self.b[j-1]:
            score[0] = self.H[i-1,j-1] + self.m
        else:
            score[0] = self.H[i-1,j-1] + self.ms
        # open gap has penalty > continue a gap
        # if self.T[i-1, j]
        score[2] = self.Wi + self.H[i, j-1] # np.max(self.H[i, :j]), insertion
        if self.T[i-1, j] == 2: # Gap continue
            score[1] = self.Wd + self.H[i-1, j] # deletion
        else: # Gap open
            score[1] = self.Go + self.H[i-1, j] # deletion
        if self.T[i, j-1] == 3: # Gap continue
            score[2] = self.Wi + self.H[i, j-1] # insertion
        else: # Gap open
            score[2] = self.Go + self.H[i, j-1] # insertion
        # find max
        tmp = score[0]
        itmp = 1
        if score[1] > tmp:
            tmp = score[1]
            itmp = 2
        if score[2] > tmp:
            tmp = score[2]
            itmp = 3
        self.H[i,j] = tmp
        self.T[i,j] = itmp
        return None
    def align(self, indel_str = "-"):
        """ Align using Smith-Waterman algorithm
        Args:
            indel_str: string to visualize a gap (indel)
        """
        r, c = self.H.shape
        for i in xrange(r):
            for j in xrange(c):
                self._align_next(i, j)
        im = np.argmax(self.H[-1, :])
        jm = np.argmax(self.H[:, -1])
        if self.H[-1, im] > self.H[jm, -1]:
            i = r-1
            j = im
        else:
            i = jm
            j = c-1
        path = []
        a = b = ""
        if i < r-1:
            a += self.a[i:]
            b += indel_str * (r-1-i)
        if j < c-1:
            b += self.b[j:]
            a += indel_str * (c-1-j)
        while i > 0 and j > 0:
            path.append(self.T[i,j])
            if self.T[i,j] == 1:
                a = self.a[i-1] + a
                b = self.b[j-1] + b
                i = i-1
                j = j-1
            elif self.T[i,j] == 2:
                a = self.a[i-1] + a
                b = indel_str + b
                i = i-1
            else: # self.T[i,j] == 3:
                a = indel_str + a
                b = self.b[j-1] + b
                j = j-1
        if i > 0:
            a = self.a[:i] + a
            b = indel_str * i + b
        if j > 0:
            a = indel_str * j + a
            b = self.b[:j] + b
        path.reverse()
        self.start = (i,j)
        self.aligned_string = (a, b)
        self.path = path
        return None
    def show(self, by = 100, show_match = True, match_char = "|"):
        """Print Alignment result
        Args:
             by: Number of character per line
             show_match: if to connected matched pairs
             match_char: character to show matched pairs
        """
        if by <= 0:
            by = len(self.aligned_string[0])
        if show_match:
            match = "".join([match_char if p[0] == p[1] else " " for p in zip(*self.aligned_string)])
        i = 0
        j = by
        l = len(self.aligned_string[0])
        while i < l:
            if i > 0: print
            print self.aligned_string[0][i:j]
            if show_match: 
                print match[i:j]
            print self.aligned_string[1][i:j]
            i = j
            j += by
            if (j > l): j = l
        return None

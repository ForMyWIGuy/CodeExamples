"""
Create an array that collects counts
of the values in another array. When all
counts are >= 1 in the tallies array,
then the frog can cross because there exists
a leaf at each position to get to the end point
or whatever x is set equal to.
the return value is the index # from A
which contained the final element to be 1 in the
tallied array.
"""


def solution(A, m):
    # m = 5
    # A = [0, 1, 3, 1, 4, 2, 3, 2, 1, 3, 1, 4, 2, 4, 5, 4]
    n = len(A)
    print(n)
    print(f"A: {A}")
    for i in range(0,n):
        print(f"A{i}: {A[i]}")
    count = [0] * (m + 1)
    print(count)
    for k in range(n):
        print(f"A{k} = {A[k]}")
        count[A[k]] += 1
        print(f"count array: {count}")
        if 0 not in count:
            print(count)
            return k



import random
import unittest
class TestFrogs(unittest.TestCase):
    def test_1(self):
        A = [0, 1, 3, 1, 4, 2, 3, 2, 1, 3, 1, 4, 2, 4, 5, 4]
        m = 5
        count = solution(A, m)
        self.assertEqual(count, 14)

    def test_lrgValues(self):
        A = []
        m = 20
        for i in range(0, m+1):
            A.append(i)
            random.shuffle(A)
        k = solution(A,m)
        self.assertEqual(k, 6)


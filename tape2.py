import random
import numpy as np

def solution(A):
    length = len(A)
    left_total = 0
    right_total = 0
    # print(sum(A))
    minimum_diff = 100000000
    # print(f"min_diff: {minimum_diff}")

    for i in range(1, length):
        l_output = A[(-length):i]
        # print(f" Left output = {l_output}")
        left_total = sum(l_output)
        # print(f" Left total = {left_total}")
        r_output = A[i:length:]
        # print(f" r_output = {r_output}")
        right_total = (r_output)
        # print(f"Right_total = {right_total}")

        difference = abs(left_total - right_total)
        print(f"left - right = diff: {left_total} - {right_total} = {difference}")
        if difference <= minimum_diff:
            minimum_diff = difference
            # print(f">>>> min_diff: {minimum_diff}")
    return minimum_diff

"""
https://app.codility.com/demo/results/trainingF772HR-G92/
38% -- no points on performance, talked with Dave and
sum calculated each time in the for loop is more time consuming
error on the value of minimum_diff - I used abs(sum(A)*2) and this
fails when I get -1000, 1000.  Sum is 0 so never changes to a
value larger than zero

https://app.codility.com/demo/results/trainingTPUG3R-25B/
53% -- still no points for performance, but I understand why now.
design decision to consider for next exercise:
calling Sum() each time in the for loop is time consuming,
instead declare variables:
left_side = A[0]
right_side = sum(A) - left_side
for items in range of A, take slices as I did before
and update to left_side + A[i]
and right_side = sum(A) - left_side
current_difference = abs(left_side - right_side)
if current_difference < smallest_diff:
    smallest_difference = current_difference
"""
A = []
A = np.random.randint(-1000,1000, 2)
#nrandom.shuffle(A)
print(A)

import unittest
class TestTape(unittest.TestCase):
    def test_1(self):
        A = [3, 1, 2, 4, 3]
        minimum_diff = solution(A)
        self.assertEqual(minimum_diff, 1)

    def test_2(self):
        A = [300, -1, 20, 14, 350, 20]
        minimum_diff = solution(A)
        self.assertEqual(minimum_diff, 37)

    def test_negative(self):
        A = [-300, -1, -20, -140]
        minimum_diff = solution(A)
        self.assertEqual(minimum_diff, 139)

    def test_few(self):
        A = [300, 350]
        minimum_diff = solution(A)
        self.assertEqual(minimum_diff, 50)

    def test_nodiff(self):
        A = [300, 300]
        minimum_diff = solution(A)
        self.assertEqual(minimum_diff, 0)

    def test_bigNsmall(self):
        A = [1000, -1000]
        minimum_diff = solution(A)
        self.assertEqual(minimum_diff, 2000)

    def test_repeats(self):
        A = [3, 3, 3, 3, 3, 3, 3, 4]
        minimum_diff = solution(A)
        self.assertEqual(minimum_diff, 1)

    def test_lrg(self):
        A = [300, 350, 1000, -1000, 500, -500, 300, 350, 1000, 500]
        minimum_diff = solution(A)
        self.assertEqual(minimum_diff, 200)
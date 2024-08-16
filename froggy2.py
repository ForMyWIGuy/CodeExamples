# 100% correct results in all cases, but performance was too slow 0%
# https://app.codility.com/demo/results/trainingZC9MNQ-VMH/
# inputs 10, 85, 30 -- time results
"""
real    0m0.016s
user    0m0.011s
sys     0m0.004s
"""

# inputs 1000, 1,000,000, 10
"""
99900

real    0m0.034s
user    0m0.027s
sys     0m0.005s
"""

x = 17
y = 4099
d = 17
count = 0
current_total = x

if x == y:
    print(count)

for i in range(x, y, d):
    count = count + 1
    current_total = current_total + d
print(count)
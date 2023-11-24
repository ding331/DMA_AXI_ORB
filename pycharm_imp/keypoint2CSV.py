import csv

# 二維表格
table = [
    ['軟,硬體準確率比較', '關鍵點總數(樣本)', '關鍵點總數(測試)', 'matching總數', 'inliers', 'inliers(%)'],
    ['python', kpts1, kpts2, matched1, inliers1, inlier_ratio],
    ['FPGA_zedboard', 1, 1, 1, 1, 1]
]

# 二維表格'樣本的x', '樣本的y',  '測試的x', '測試的y'
table2 = [
    ['軟,硬體單點比較(同位置的關鍵點)', '關鍵點座標(float32)', '特徵點的歐式距離', 'arctan角度(特徵點方向)', 'R值'],
    ['python', kp1[matches[0].queryIdx].pt, matches[0].distance, matches[0].angle, kp1[matches[0].queryIdx].response],
    ['FPGA_zedboard', ]
]

with open('ORB_output.csv', 'w', newline='') as csvfile:
  writer = csv.writer(csvfile)

  # 寫入二維表格
  writer.writerows(table)
  writer.writerows([ ])
  writer.writerows(table2)
  
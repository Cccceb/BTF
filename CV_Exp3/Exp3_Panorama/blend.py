import math
import sys
import scipy
import cv2
import numpy as np
import random
from scipy.stats import norm
class ImageInfo:
    def __init__(self, name, img, position):
        self.name = name
        self.img = img
        self.position = position


def imageBoundingBox(img, M):
    """
       This is a useful helper function that you might choose to implement
       that takes an image, and a transform, and computes the bounding box
       of the transformed image.

       INPUT:
         img: image to get the bounding box of
         M: the transformation to apply to the img
       OUTPUT:
         minX: int for the minimum X value of a corner
         minY: int for the minimum Y value of a corner
         maxX: int for the maximum X value of a corner
         maxY: int for the maximum Y value of a corner
    """
    #TODO 8
    #TODO-BLOCK-BEGIN

    # minX = 10000
    # minY = 10000
    # maxX = 0
    # maxY = 0
    # for i in range(img.shape[0]):
    #     for j in range(img.shape[1]):
    #         a = np.array([[i, j, 1]]).T
    #         a = np.dot(M, a)
    #         minX = min(minX, a[0])
    #         maxX = max(maxX, a[0])
    #         minY = min(minY, a[1])
    #         maxY = max(maxY, a[1])

    row, col = img.shape[:2]

    cor = np.array([[0, 0, col - 1, col - 1],
                       [0, row - 1, 0, row - 1],
                       [1, 1, 1, 1]])
    res = np.dot(M, cor)
    res = res / res[-1]
    minX, minY, _ = np.min(res, axis=1)
    maxX, maxY, _ = np.max(res, axis=1)



    #raise Exception("TODO in blend.py not implemented")
    #TODO-BLOCK-END
    return int(minX), int(minY), int(maxX), int(maxY)

def accumulateBlend(img, acc, M, blendWidth):
    """
       INPUT:
         img: image to add to the accumulator
         acc: portion of the accumulated image where img should be added
         M: the transformation mapping the input image to the accumulator
         blendWidth: width of blending function. horizontal hat function
       OUTPUT:
         modify acc with weighted copy of img added where the first
         three channels of acc record the weighted sum of the pixel colors
         and the fourth channel of acc records a sum of the weights
    """


    rows_bg, cols_bg, _ = acc.shape
    rows, cols = img.shape[:2]
    img = cv2.copyMakeBorder(img, 0, rows_bg - rows, 0, cols_bg - cols, cv2.BORDER_CONSTANT, value=0)

    # BEGIN TODO 10
    # Fill in this routine
    #TODO-BLOCK-BEGIN


    row, col, _ = img.shape
    x_range = np.arange(col)
    y_range = np.arange(row)
    (x_grid, y_grid) = np.meshgrid(x_range, y_range)    #生成网格点矩阵
    ones = np.ones((row, col))
    qc_zuobiao = np.dstack((x_grid, y_grid, ones))     # 生成网格点齐次坐标
    qc_zuobiao = qc_zuobiao.reshape((col * row, 3))
    qc_zuobiao = qc_zuobiao.T

    dst_zuobiao = np.linalg.inv(M).dot(qc_zuobiao) # 将图像映射到目标位置
    dst_zuobiao = dst_zuobiao / dst_zuobiao[2]   # 转回平面坐标

    x_mian = dst_zuobiao[0].reshape((row, col)).astype(np.float32)  # x坐标
    y_mian = dst_zuobiao[1].reshape((row, col)).astype(np.float32)  # y坐标

    img_warped = cv2.remap(img, x_mian, y_mian, cv2.INTER_LINEAR) # 通过remap将强度赋给目标图像完成卷绕

    (minX, minY, maxX, maxY) = imageBoundingBox(img, M)
    dst_img = np.dstack((img_warped, np.ones((img_warped.shape[0], img_warped.shape[1], 1)) ))

    # print(dst_img.shape)
    # cv2.imwrite("dst2_" + str(random.randint(1, 1000)) + ".jpg", dst_img[minX:(cols_bg - 1 - minX),:,:])
    # base_2 = random.uniform((0 - 0) / blendWidth, (1 - 0) / blendWidth)
    # base_2 = norm.rvs(base_2, size=cols_bg)
    # base_2 = (base_2 * blendWidth)
    # print(base_2)
    # base = np.array(base_2)
    # print("base",base.shape)

    base = np.linspace(-minX / blendWidth, (cols_bg - minX -1) / blendWidth, cols_bg )
    #求一个和背景一样宽的等差数列，用于羽化
    right = np.clip(base , 0, 1).reshape((1, cols_bg, 1))
    # print("right", right.shape)
    left = np.ones((1, cols_bg, 1)) - right
    # print("dst_img",dst_img.shape)
    feathered_img = right * dst_img
    acc *= left

    grayimg = cv2.cvtColor(img_warped, cv2.COLOR_BGR2GRAY)
    maskimg = (grayimg != 0).reshape((rows_bg, cols_bg, 1))
    dst_img = maskimg * feathered_img
    # dst_img *= maskimg



    grayacc = cv2.cvtColor(acc[:, :, :3].astype(np.uint8), cv2.COLOR_BGR2GRAY)
    maskacc = (grayacc != 0).reshape((rows_bg, cols_bg, 1))
    acc *= maskacc

    acc += dst_img
    graypy = (pyramid(grayacc,grayimg)!=0).reshape((rows_bg, cols_bg, 1))
    # acc+=pyramid(acc,dst_img)
    # grayacc = cv2.cvtColor(acc[:, :, :3].astype(np.uint8), cv2.COLOR_BGR2GRAY)
    # maskacc = (grayacc != 0).reshape((rows_bg, cols_bg, 1))
    # acc *= maskacc
    acc *= graypy

    # cv2.imwrite(r"D:\CV_resorce\Ex3_resources\Test_Pyramid\acc_" + str(random.randint(1, 17)) + ".jpg", acc)
    # print("acc",acc[:,:,:3].shape,type(acc[0][0][0]))
    # print("img_masked",img_masked[:,:,:3].shape,type(img_masked[0][0][0]))
    # acc = Pyramid(acc[:,:1632,:],dst_img[:,:1632,:])
    # cv2.imshow("img_" + str(random.randint(1, 1000)) , acc)
    # cv2.waitKey()
    # raise Exception("TODO in blend.py not implemented")
    #TODO-BLOCK-END
    # END TODO

def sameSize(img1, img2):
    rows, cols = img2.shape
    dst = img1[:rows, :cols]
    return dst
def pyramid(A,B):

    g = A.copy()
    gp_a = [g]
    # print("A",A.shape)
    # print("B",B.shape)
    for i in range(6):
        g = cv2.pyrDown(g)
        gp_a.append(g)

    g = B.copy()
    gp_b = [g]
    for i in range(6):
        g = cv2.pyrDown(g)
        gp_b.append(g)

    # generate Laplacian Pytamid for apple
    lp_a = [gp_a[5]]
    for i in range(5, 0, -1):
        ge = cv2.pyrUp(gp_a[i])
        l = cv2.subtract(gp_a[i - 1], sameSize(ge, gp_a[i - 1]))
        lp_a.append(l)

    # generate Laplacian Pyramid for B
    lp_b = [gp_b[5]]
    for i in range(5, 0, -1):
        ge = cv2.pyrUp(gp_b[i])
        l = cv2.subtract(gp_b[i - 1], sameSize(ge, gp_b[i - 1]))
        lp_b.append(l)

    ls1 = []
    for la, lb in zip(lp_a, lp_b):
        rows, cols= la.shape
        ls = cv2.add(la,lb)
        # ls = np.hstack((la[:,0:cols//2], lb[:,cols//2:]))
        # ls = la +lb # 这个位置不应该是加，但是也不知道是啥
        ls1.append(ls)

    ls2 = ls1[0]
    for i in range(1, 6):
        ls2 = cv2.pyrUp(ls2)
        ls2 = cv2.add(sameSize(ls2, ls1[i]), ls1[i])

    return ls2

def normalizeBlend(acc):
    """
       INPUT:
         acc: input image whose alpha channel (4th channel) contains
         normalizing weight values
       OUTPUT:
         img: image with r,g,b values of acc normalized
    """
    # BEGIN TODO 11
    # fill in this routine..
    acc[:, :, 3][acc[:, :, 3] == 0] = 1  # 避免除零错误
    img = acc / acc[:, :, 3].reshape((acc.shape[0], acc.shape[1], 1))
    img = img[:, :, :3].astype(np.uint8)    # 不加这个报错啊。。枯了
    # img = acc[:, :, :3].astype(np.uint8)    # 不加这个报错啊。。枯了
    # cv2.imshow("img" + str(random.randint(1, 1000)), img)
    #TODO-BLOCK-BEGIN
    # raise Exception("TODO in blend.py not implemented")
    #TODO-BLOCK-END
    # END TODO
    return img


def getAccSize(ipv):
    """
       This function takes a list of ImageInfo objects consisting of images and
       corresponding transforms and Returns useful information about the accumulated
       image.

       INPUT:
         ipv: list of ImageInfo objects consisting of image (ImageInfo.img) and transform(image (ImageInfo.position))
       OUTPUT:
         accWidth: Width of accumulator image(minimum width such that all tranformed images lie within acc)
         accHeight: Height of accumulator image(minimum height such that all tranformed images lie within acc)

         channels: Number of channels in the accumulator image
         width: Width of each image(assumption: all input images have same width)
         translation: transformation matrix so that top-left corner of accumulator image is origin
    """

    # Compute bounding box for the mosaic
    minX = sys.maxsize
    minY = sys.maxsize
    maxX = 0
    maxY = 0
    channels = -1
    width = -1  # Assumes all images are the same width
    M = np.identity(3)
    for i in ipv:
        M = i.position
        img = i.img
        _, w, c = img.shape
        if channels == -1:
            channels = c
            width = w

        # BEGIN TODO 9
        # add some code here to update minX, ..., maxY
        #TODO-BLOCK-BEGIN

        x1, y1, x2, y2 = imageBoundingBox(img, M)
        minX = min(minX, x1)
        minY = min(minY, y1)
        maxX = max(maxX, x2)
        maxY = max(maxY, y2)
        #raise Exception("TODO in blend.py not implemented")
        #TODO-BLOCK-END
        # END TODO

    # Create an accumulator image
    accWidth = int(math.ceil(maxX) - math.floor(minX))
    accHeight = int(math.ceil(maxY) - math.floor(minY))
    print ('accWidth, accHeight:', (accWidth, accHeight))
    translation = np.array([[1, 0, -minX], [0, 1, -minY], [0, 0, 1]])

    return accWidth, accHeight, channels, width, translation


def pasteImages(ipv, translation, blendWidth, accWidth, accHeight, channels):
    acc = np.zeros((accHeight, accWidth, channels + 1))
    # Add in all the images
    M = np.identity(3)
    for count, i in enumerate(ipv):
        M = i.position
        img = i.img

        M_trans = translation.dot(M)
        accumulateBlend(img, acc, M_trans, blendWidth)

    return acc


def getDriftParams(ipv, translation, width):
    # Add in all the images
    M = np.identity(3)
    for count, i in enumerate(ipv):
        if count != 0 and count != (len(ipv) - 1):
            continue

        M = i.position

        M_trans = translation.dot(M)

        p = np.array([0.5 * width, 0, 1])
        p = M_trans.dot(p)

        # First image
        if count == 0:
            x_init, y_init = p[:2] / p[2]
        # Last image
        if count == (len(ipv) - 1):
            x_final, y_final = p[:2] / p[2]

    return x_init, y_init, x_final, y_final


def computeDrift(x_init, y_init, x_final, y_final, width):
    A = np.identity(3)
    drift = (float)(y_final - y_init)
    # We implicitly multiply by -1 if the order of the images is swapped...
    length = (float)(x_final - x_init)
    A[0, 2] = -0.5 * width
    # Negative because positive y points downwards
    A[1, 0] = -drift / length

    return A


def blendImages(ipv, blendWidth, is360=False, A_out=None):
    """
       INPUT:
         ipv: list of input images and their relative positions in the mosaic
         blendWidth: width of the blending function
       OUTPUT:
         croppedImage: final mosaic created by blending all images and
         correcting for any vertical drift
    """
    accWidth, accHeight, channels, width, translation = getAccSize(ipv)
    acc = pasteImages(
        ipv, translation, blendWidth, accWidth, accHeight, channels
    )
    compImage = normalizeBlend(acc)

    # Determine the final image width
    outputWidth = (accWidth - width) if is360 else accWidth
    x_init, y_init, x_final, y_final = getDriftParams(ipv, translation, width)
    # Compute the affine transform
    A = np.identity(3)
    # BEGIN TODO 12
    # fill in appropriate entries in A to trim the left edge and
    # to take out the vertical drift if this is a 360 panorama
    # (i.e. is360 is true)
    # Shift it left by the correct amount
    # Then handle the vertical drift
    # Note: warpPerspective does forward mapping which means A is an affine
    # transform that maps accumulator coordinates to final panorama coordinates
    #TODO-BLOCK-BEGIN
    if is360:
        A = computeDrift(x_init, y_init, x_final, y_final, width)
    # raise Exception("TODO in blend.py not implemented")
    #TODO-BLOCK-END
    # END TODO

    if A_out is not None:
        A_out[:] = A

    # Warp and crop the composite
    croppedImage = cv2.warpPerspective(
        compImage, A, (outputWidth, accHeight), flags=cv2.INTER_LINEAR
    )

    return croppedImage

if __name__ == '__main__':
    # A = cv2.imread("D:\CV_resorce\Ex3_resources\img_18.jpg")
    # B = cv2.imread("D:\CV_resorce\Ex3_resources\img_382.jpg")
    A = cv2.imread("D:\CV_resorce\Ex3_resources\img_2.jpg")
    B = cv2.imread("D:\CV_resorce\Ex3_resources\img_572.jpg")
    cv2.imshow('1', A)
    cv2.imshow('2', B)
    con =pyramid(B,A)
    # cv2.imshow('1',normalizeBlend(con))
    cv2.imshow('3',con)
    # cv2.imwrite("img_2.jpg",)
    cv2.waitKey()
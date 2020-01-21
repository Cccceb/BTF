# Please place imports here.
# BEGIN IMPORTS
import time
import  math
from math import floor
import numpy as np
import cv2
# import tests
from scipy.sparse import csr_matrix
# import util_sweep
# END IMPORTS


def compute_photometric_stereo_impl(lights, images):
    """
    Given a set of images taken from the same viewpoint and a corresponding set
    of directions for light sources, this function computes the albedo and
    normal map of a Lambertian scene.

    If the computed albedo for a pixel has an L2 norm less than 1e-7, then set
    the albedo to black and set the normal to the 0 vector.

    Normals should be unit vectors.

    Input:
        lights -- N x 3 array.  Rows are normalized and are to be interpreted
                  as lighting directions.
        images -- list of N images.  Each image is of the same scene from the
                  same viewpoint, but under the lighting condition specified in
                  lights.
    Output:
        albedo -- float32 height x width x 3 image with dimensions matching the
                  input images.
        normals -- float32 height x width x 3 image with dimensions matching
                   the input images.
    """
    # raise NotImplementedError()
    # images是个列表！！！！
    lg = len(images)
    height, width, channels = images[0].shape
    normals = np.zeros((height, width, 3))  # 图像
    albedo = np.zeros((height, width, channels))  # 反照率
    N = np.zeros((3, 1))
    images = np.array(images)
    for i in range(height):
        for j in range(width):
            for k in range(channels):
                I = images[:, i, j, k]
                LTL = np.dot(lights.T, lights)
                LTI = np.dot(lights.T, I)
                G = np.dot(np.linalg.inv(LTL), LTI).reshape(3, 1)
                kd = np.linalg.norm(G)
                if kd < 1e-7:  # 如果小于1e-7，则将反照率置为黑，法线置为0
                    albedo[i, j, k] = 0
                    N = np.zeros((3, 1))
                else:
                    albedo[i, j, k] = kd
                    N = ((1. / kd) * G).reshape((3, 1))
            normals[i, j, 0] = N[0, 0]
            normals[i, j, 1] = N[1, 0]
            normals[i, j, 2] = N[2, 0]

    return albedo, normals


def project_impl(K, Rt, points):
    """
    Project 3D points into a calibrated camera.     将3D点投影到二维平面
    Input:
        K -- camera intrinsics calibration matrix   相机内参数
        Rt -- 3 x 4 camera extrinsics calibration matrix    外参数
        points -- height x width x 3 array of 3D points     点集
    Output:
        projections -- height x width x 2 array of 2D projections  二维投影阵列
    """
    # raise NotImplementedError()
    height ,width ,channels = points.shape
    projections = np.zeros((height,width,2))
    tmp = np.dot(K,Rt)      ##3*4
    up = np.array([[1]])
    for i in range(height):
        for j in range(width):
            uk = points[i,j,:].reshape(3,1)
            # print(uk.shape)
            uk = np.r_[uk,up]
            uref = np.dot(tmp,uk)
            uref /= uref[2,0]
            projections[i,j,:] = uref[:2,0]

    return projections

def preprocess_ncc_impl(image, ncc_size):
    """

    Prepare normalized patch vectors according to normalized cross
    correlation.

    This is a preprocessing step for the NCC pipeline.  It is expected that
    'preprocess_ncc' is called on every input image to preprocess the NCC
    vectors and then 'compute_ncc' is called to compute the dot product
    between these vectors in two images.

    这是NCC管道的预处理步骤。人们期望
    'preprocess_ncc'在每个输入图像上被调用来预处理NCC
    然后调用'compute_ncc'来计算点积
    在这两个图像中的向量之间。


    NCC preprocessing has two steps.
    (1) Compute and subtract the mean.      求每个点与平均值的差
    (2) Normalize the vector.           归一化

    The mean is per channel.
    i.e. For an RGB image, over the ncc_size**2 patch, compute the R, G, and B means separately.
    The normalization is over all channels.
    i.e. For an RGB image, after subtracting out the RGB mean, compute the norm over the entire (ncc_size**2 * channels)
    vector and divide.
    平均值是每个频道。例如，对于RGB图像，超过ncc_size**2
    分别计算R G B。正常化
    所有频道都有。例如，对于一个RGB图像，减去
    RGB平均值，计算整个通道的范数(ncc_size**2 * channel)
    向量和分裂。


    If the norm of the vector is < 1e-6, then set the entire vector for that
    patch to zero.
    如果向量的模值小于1e-6，则看成0

    Patches that extend past the boundary of the input image at all should be
    considered zero.  Their entire vector should be set to 0.
    扩展的边界看作0

    Patches are to be flattened into vectors with the default numpy row
    major order.  For example, given the following
    2 (height) x 2 (width) x 2 (channels) patch, here is how the output
    vector should be arranged.

    行序为主序最后是通道展开数组

    channel1         channel2
    +------+------+  +------+------+ height
    | x111 | x121 |  | x112 | x122 |  |
    +------+------+  +------+------+  |
    | x211 | x221 |  | x212 | x222 |  |
    +------+------+  +------+------+  v
    width ------->

    v = [ x111, x121, x211, x221, x112, x122, x212, x222 ]

    see order argument in np.reshape

    Input:
        image -- height x width x channels image of type float32
        ncc_size -- integer width and height of NCC patch region.
    Output:
        normalized -- heigth x width x (channels * ncc_size**2) array
    """
    # raise NotImplementedError()
    #  preprocess_ncc_impl 为预处理，即计算一幅图像每个像素点周围 patch 中的
    # 值：

    #求平均时，每个通道单独做。归一化时（即做除法时），对所有通道一起做
    # print("preprocess_ncc_impl")
    # raise NotImplementedError()

    height, width, channels = image.shape
    normalized = np.zeros((height,width,channels*ncc_size**2))
    size = ncc_size // 2  #patch 为ncc_size*ncc_size的正方形,size为半径
    tmp = []
    fm_array = np.zeros((height, width,1))  #归一化用
    for k in range(channels):   #每个通道单独做。
        tmp_array = np.zeros((height, width, ncc_size ** 2))
        for i in range(height):
            for j in range(width):
                if (i - size) >= 0 and j - size >= 0 and i + size < height and j + size < width:
                    patch = image[(i - size):(i + size + 1), (j - size):(j + size + 1), k]
                    means = np.mean(np.mean(patch,axis=1),axis=0).reshape(1,-1)
                    delta = patch - means
                    tmp_array[i,j,:] = delta.reshape((1,1,ncc_size**2))
                    fm_array[i,j] += np.sum(delta ** 2)
                else:
                    tmp_array[i, j, :] = 0
        tmp.append(tmp_array)
    fm_array = np.clip(fm_array,1e-6,1000000) # 不能太小，否则nan  这个上限写np.max()居然不行

    normalized = np.dstack(tmp) 
    normalized /= np.sqrt(fm_array) # 归一化时（即做除法时），对所有通道一起做

    return normalized

def compute_ncc_impl(image1, image2):
    """
    Compute normalized cross correlation between two images that already have
    normalized vectors computed for each pixel with preprocess_ncc.
    计算已经存在的两个图像之间的归一化互相关
    使用preprocess_ncc计算每个像素的归一化向量。
    Input:
        image1 -- height x width x (channels * ncc_size**2) array
        image2 -- height x width x (channels * ncc_size**2) array
    Output:
        ncc -- height x width normalized cross correlation between image1 and
               image2.

               图1和图2的内积
    """
    # raise NotImplementedError()
    height, width, channels = image1.shape
    ncc = np.zeros((height, width))
    for i in range(height):
        for j in range(width):
            ncc[i, j] = np.sum(image1[i, j, :] * image2[i, j, :])
    return ncc

def form_poisson_equation_impl(height, width, alpha, normals, depth_weight, depth):
    """
    Creates a Poisson equation given the normals and depth at every pixel in image.
    The solution to Poisson equation is the estimated depth. 
    When the mode, is 'depth' in 'combine.py', the equation should return the actual depth.
    When it is 'normals', the equation should integrate the normals to estimate depth.
    When it is 'both', the equation should weight the contribution from normals and actual depth,
    using  parameter 'depth_weight'.



    Input:
        height -- height of input depth,normal array
        width -- width of input depth,normal array
        alpha -- stores alpha value of at each pixel of image. 
            If alpha = 0, then the pixel normal/depth should not be 
            taken into consideration for depth estimation
        normals -- stores the normals(nx,ny,nz) at each pixel of image
            None if mode is 'depth' in combine.py
        depth_weight -- parameter to tradeoff between normals and depth when estimation mode is 'both'
            High weight to normals mean low depth_weight.
            Giving high weightage to normals will result in smoother surface, but surface may be very different from
            what the input depthmap shows.

        depth -- stores the depth at each pixel of image
            None if mode is 'normals' in combine.py
    Output:
        constants for equation of type Ax = b
        A -- left-hand side coefficient of the Poisson equation 
            note that A can be a very large but sparse matrix so csr_matrix is used to represent it.
        b -- right-hand side constant of the the Poisson equation
    """

    assert alpha.shape == (height, width)
    assert normals is None or normals.shape == (height, width, 3)
    assert depth is None or depth.shape == (height, width)

    '''
    Since A matrix is sparse, instead of filling matrix, we assign values to a non-zero elements only.
    For each non-zero element in matrix A, if A[i,j] = v, there should be some index k such that, 
    对于矩阵A中的每个非零元素，如果A[i,j] = v，应该有某个指标k，使得，
        row_ind[k] = i
        col_ind[k] = j
        data_arr[k] = v
    Fill these values accordingly
    '''
    row_ind = []
    col_ind = []
    data_arr = []
    '''
    For each row in the system of equation fill the appropriate value for vector b in that row
    '''
    b = []
    if depth_weight is None:
        depth_weight = 1

    '''
    TODO
    Create a system of linear equation to estimate depth using normals and crude depth Ax = b

    x is a vector of depths at each pixel in the image and will have shape (height*width)

    If mode is 'depth':
        > Each row in A and b corresponds to an equation at a single pixel
            A和b中的每一行对应一个像素处的方程
        > For each pixel k, 
            
            if pixel k has alpha value zero do not add any new equation.
            
            else, fill row in b with depth_weight*depth[k] and 
            fill column k of the corresponding row in A with depth_weight.
            
            
        Justification: 
            Since all the elements except k in a row is zero, this reduces to 
                depth_weight*x[k] = depth_weight*depth[k]
            you may see that, solving this will give x with values exactly same as the depths, 
            at pixels where alpha is non-zero, then why do we need 'depth_weight' in A and b?
            The answer to this will become clear when this will be reused in 'both' mode

    Note: The normals in image are +ve when they are along an +x,+y,-z axes, if seen from camera's viewpoint.
    If mode is 'normals':
        > Each row in A and b corresponds to an equation of relationship between adjacent pixels
        > For each pixel k and its immideate neighbour along x-axis l
            
            if any of the pixel k or pixel l has alpha value zero do not add any new equation.
            
            else, fill row in b with nx[k] (nx is x-component of normal), 
            
            fill column k of the corresponding row in A with -nz[k] and column k+1 with value nz[k]
            
        > Repeat the above along the y-axis as well, except nx[k] should be -ny[k].
            

        Justification: Assuming the depth to be smooth and almost planar within one pixel width.
        The normal projected in xz-plane at pixel k is perpendicular to tangent of surface in xz-plane.
        In other word if n = (nx,ny,-nz), its projection in xz-plane is (nx,nz) and if tangent t = (tx,0,tz),
            then n.t = 0, therefore nx/-nz = -tz/tx
        Therefore the depth change with change of one pixel width along x axis should be proporational to tz/tx = -nx/nz
        In other words (depth[k+1]-depth[k])*nz[k] = nx[k]
        This is exactly what the equation above represents.
        The negative sign in ny[k] is because the indexing along the y-axis is opposite of +y direction.

    If mode is 'both':
        > Do both of the above steps.

        Justification: The depth will provide a crude estimate of the actual depth. The normals do the smoothing of depth map
        This is why 'depth_weight' was used above in 'depth' mode. 
            If the 'depth_weight' is very large, we are going to give preference to input depth map.
            If the 'depth_weight' is close to zero, we are going to give preference normals.
    '''
    #TODO Block Begin
    #fill row_ind,col_ind,data_arr,b
    # raise NotImplementedError()
    '''
    depth时，返回实际深度。
    normal时，该方程应结合法线来估计深度。
    当都是时，应该按照depth_weight加权。赋予法线较高的重量会导致表面更光滑，但表面可能会和输入深度图显示了什么有很大不同
    
    由于稀疏矩阵，所以用类似三元组存储
    row_ind = []
    col_ind = []
    data_arr = []
    
    csr_matrix 用来表示A
    
    如果alpha = 0，跳过
    '''
    '''
    对于每个像素k
    如果像素k的值为零，不要添加任何新的方程。
    否则，用depth_weight*depth[k]填充b中的行，并用depth_weight填充A中相应行的k列。
    '''
    row = 0
    # col = 0
    if depth is not None:
        for i in range(height):
            for j in range(width):
                if alpha[i, j] != 0:
                    row_ind.append(row)
                    row+=1
                    col_ind.append(i*width+j)
                    data_arr.append(depth_weight)
                    b.append(depth_weight * depth[i, j])

    '''
    对于每个像素k和它在x轴l上的相邻像素
    如果像素k或像素l的值为0，则不添加任何新方程。
    否则，用nx[k]填充b行(nx是法向量的x分量)
    用-nz[k]填充A中相应行的k列，用值nz[k]填充k+1列
    沿着y轴重复上面的步骤，除了nx[k]应该是-ny[k]。
    '''
    if normals is not None:
        for i in range(height):
            for j in range(width):
                if alpha[i, j] != 0 and (i + 1 < height and j + 1 < width):
                    if (alpha[i + 1, j] != 0 and alpha[i, j + 1] != 0):
                        b.append(normals[i, j, 0])  # 法线nx分量填充b

                        row_ind.append(row)
                        col_ind.append(i * width + j)
                        data_arr.append(-normals[i, j, 2])  #   -nz填充A中k列

                        row_ind.append(row)
                        col_ind.append(i * width + j + 1)
                        data_arr.append(normals[i, j, 2])   #   nz填充A中k+1列
                        row += 1

                        b.append(-normals[i, j, 1])         # 法线-ny分量填充b
                        row_ind.append(row)
                        col_ind.append(i * width + j)
                        data_arr.append(-normals[i, j, 2])      #-nz填充k行

                        row_ind.append(row)
                        col_ind.append((i + 1) * width + j)     # nz填充k+1行
                        data_arr.append(normals[i, j, 2])
                        row += 1




    #TODO Block end
    # Convert all the lists to numpy array
    row_ind = np.array(row_ind, dtype=np.int32)
    col_ind = np.array(col_ind, dtype=np.int32)
    data_arr = np.array(data_arr, dtype=np.float32)
    b = np.array(b, dtype=np.float32)

    # Create a compressed sparse matrix from indices and values
    A = csr_matrix((data_arr, (row_ind, col_ind)), shape=(row, width * height))

    return A, b


if __name__ == '__main__':
    # tests.preprocess_ncc_zeros_test()
    # tests.preprocess_ncc_delta_test()
    # tests.preprocess_ncc_uniform_test()
    # tests.preprocess_ncc_full_test()
    tests.compute_photometric_stereo_test()
    tests.compute_photometric_stereo_half_albedo_test()
    tests.compute_photometric_stereo_angle_test()




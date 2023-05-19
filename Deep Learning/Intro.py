{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "It is highly recommended to use a powerful **GPU**, you can use it for free uploading this notebook to [Google Colab](https://colab.research.google.com/notebooks/intro.ipynb).\n",
    "<table align=\"center\">\n",
    " <td align=\"center\"><a target=\"_blank\" href=\"https://colab.research.google.com/github/ezponda/intro_deep_learning/blob/main/class/CNN/Introduction_to_CNN.ipynb\">\n",
    "        <img src=\"https://i.ibb.co/2P3SLwK/colab.png\"  style=\"padding-bottom:5px;\" />Run in Google Colab</a></td>\n",
    "  <td align=\"center\"><a target=\"_blank\" href=\"https://github.com/ezponda/intro_deep_learning/blob/main/class/CNN/Introduction_to_CNN.ipynb\">\n",
    "        <img src=\"https://i.ibb.co/xfJbPmL/github.png\"  height=\"70px\" style=\"padding-bottom:5px;\"  />View Source on GitHub</a></td>\n",
    "</table>"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "<a id='Image Filtering'></a>\n",
    "# Image Filtering"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "## if you have a GPU\n",
    "GPU=False\n",
    "#%tensorflow_version 2.x\n",
    "import tensorflow as tf\n",
    "if GPU:\n",
    "    device_name = tf.test.gpu_device_name()\n",
    "    if device_name != '/device:GPU:0':\n",
    "        raise SystemError('GPU device not found')\n",
    "    print('Found GPU at: {}'.format(device_name))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "import os\n",
    "import cv2\n",
    "import matplotlib.pyplot as plt\n",
    "import numpy as np"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Load the example image.\n",
    "\n",
    "Load the example image.\n",
    "\n",
    "You can download the image with an image url using [get_file](https://www.tensorflow.org/api_docs/python/tf/keras/utils/get_file)\n",
    "```python\n",
    "tf.keras.utils.get_file(\n",
    "    fname, origin, untar=False, md5_hash=None, file_hash=None,\n",
    "    cache_subdir='datasets', hash_algorithm='auto',\n",
    "    extract=False, archive_format='auto', cache_dir=None\n",
    ")\n",
    "```"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "img_folder= '../../images'\n",
    "#url = \"https://github.com/ezponda/intro_deep_learning/blob/main/images/taj-mahal.png\"\n",
    "url = 'https://i.ibb.co/vd1SqSM/The-grandeur-of-the-Taj-Mahal-and-its-intricate-stone-inlays-immediately-greets-the-visitor-upon-ent.jpg'\n",
    "image_path = tf.keras.utils.get_file(\"taj-mahal-2.jpg\", url)\n",
    "#pic = 'taj-mahal.jpg'\n",
    "#image_path = os.path.join(img_folder, pic)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "def read_image(image_path, target_size=None):\n",
    "    image = tf.keras.preprocessing.image.load_img(image_path,\n",
    "                target_size=target_size)\n",
    "    image = tf.keras.preprocessing.image.img_to_array(image)\n",
    "    image = image.astype(np.uint8)\n",
    "    return image\n",
    "\n",
    "image = read_image(image_path)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "We can see that the dimensions of the image are (468, 468, 3). \n",
    "\n",
    "That is, the image has a resolution of **468x468 pixels**, with **3 color channels (Red, Green and Blue)**."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "image.shape"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "plt.imshow(image)\n",
    "plt.xticks([])\n",
    "plt.yticks([])\n",
    "plt.show()"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "### Convolution examples"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "The following kernel performs the identity operation. The result of the convolution returns the original image."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "identity_kernel = np.array([\n",
    "    [0, 0, 0],\n",
    "    [0, 1, 0],\n",
    "    [0, 0, 0]\n",
    "])\n",
    "\n",
    "img = cv2.filter2D(image, -1, identity_kernel)\n",
    "\n",
    "fig, ax = plt.subplots(1, figsize=(5, 5))\n",
    "ax.set_xticks([])\n",
    "ax.set_yticks([])\n",
    "plt.imshow(img);"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "The following filter applies the [Box Blur] (https://en.wikipedia.org/wiki/Box_blur), where each pixel of the resulting image has a value equal to the mean of its pixel values neighbors."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "box_blur_filter = (1/9) * np.array([\n",
    "    [1, 1, 1],\n",
    "    [1, 1, 1],\n",
    "    [1, 1, 1]\n",
    "])\n",
    "\n",
    "img = cv2.filter2D(image, -1, box_blur_filter)\n",
    "\n",
    "fig, ax = plt.subplots(1, figsize=(5, 5))\n",
    "ax.set_xticks([])\n",
    "ax.set_yticks([])\n",
    "plt.imshow(img);"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "The following example shows a filter widely used in digital image processing: the [Gaussian filtering] (https://en.wikipedia.org/wiki/Gaussian_blur)."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "gaussian_blur_filter = (1/16) * np.array([\n",
    "    [1, 2, 1],\n",
    "    [2, 4, 2],\n",
    "    [1, 2, 1]\n",
    "])\n",
    "\n",
    "img = cv2.filter2D(image, -1, gaussian_blur_filter)\n",
    "\n",
    "fig, ax = plt.subplots(1, figsize=(5, 5))\n",
    "ax.set_xticks([])\n",
    "ax.set_yticks([])\n",
    "\n",
    "plt.imshow(img);"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "We can gaussian noise to the image and see the effects "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "sigma = 20\n",
    "n, m, k = image.shape\n",
    "img_noise = img + sigma*np.random.randn(n, m, k)\n",
    "fig, ax = plt.subplots(1, figsize=(5, 5))\n",
    "ax.set_xticks([])\n",
    "ax.set_yticks([])\n",
    "\n",
    "plt.imshow(img_noise.astype(np.uint8));"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "img1 = cv2.filter2D(img_noise, -1, gaussian_blur_filter)\n",
    "\n",
    "fig, ax = plt.subplots(2, 2, figsize=(10, 10))\n",
    "\n",
    "for i in range(ax.shape[0]):\n",
    "    for j in range(ax.shape[1]):\n",
    "        ax[i,j].set_xticks([])\n",
    "        ax[i,j].set_yticks([])\n",
    "        \n",
    "ax[0, 0].set_title('Original Image')\n",
    "ax[0, 0].imshow(image.astype(np.uint8));\n",
    "\n",
    "ax[0, 1].set_title('Noisy Image')\n",
    "ax[0, 1].imshow(img_noise.astype(np.uint8));\n",
    "\n",
    "ax[1, 0].set_title('Box Blur')\n",
    "ax[1, 0].imshow(cv2.filter2D(img_noise, -1, box_blur_filter).astype(np.uint8));\n",
    "\n",
    "ax[1, 1].set_title('Gaussian Blur')\n",
    "ax[1, 1].imshow(cv2.filter2D(img_noise, -1, gaussian_blur_filter).astype(np.uint8));"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "The following filter is used for edge detection in images."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "edge_detection_filter = np.array([\n",
    "    [1, 0, -1],\n",
    "    [1, 0, -1],\n",
    "    [1, 0, -1]\n",
    "])\n",
    "\n",
    "img = cv2.filter2D(image, -1, edge_detection_filter)\n",
    "\n",
    "fig, ax = plt.subplots(1, figsize=(5, 5))\n",
    "plt.xticks([])\n",
    "plt.yticks([])\n",
    "\n",
    "plt.imshow(img);"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "edge_detection_filter = np.array([\n",
    "    [0, 1, 0],\n",
    "    [1, -4, 1],\n",
    "    [0, 1, 0]\n",
    "])\n",
    "\n",
    "img = cv2.filter2D(image, -1, edge_detection_filter)\n",
    "\n",
    "fig, ax = plt.subplots(1, figsize=(5, 5))\n",
    "plt.xticks([])\n",
    "plt.yticks([])\n",
    "\n",
    "plt.imshow(img);"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "edge_detection_filter = np.array([\n",
    "    [1, 1, 1],\n",
    "    [1, -8, 1],\n",
    "    [1, 1, 1]\n",
    "])\n",
    "\n",
    "img = cv2.filter2D(image, -1, edge_detection_filter)\n",
    "\n",
    "fig, ax = plt.subplots(1, figsize=(5, 5))\n",
    "plt.xticks([])\n",
    "plt.yticks([])\n",
    "\n",
    "plt.imshow(img);"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "The following filter allows you to highlight the edges of the image by increasing its contrast. The filter is the result of subtracting the matrix of an edge detection filter from the matrix of an identity filter:"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "sharpen_flter = np.array([\n",
    "    [0, -1, 0],\n",
    "    [-1, 5, -1],\n",
    "    [0, -1, 0]\n",
    "])\n",
    "\n",
    "img = cv2.filter2D(image, -1, sharpen_flter)\n",
    "\n",
    "fig, ax = plt.subplots(1, figsize=(5, 5))\n",
    "plt.xticks([])\n",
    "plt.yticks([])\n",
    "plt.imshow(img);"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "OpenCV provides a multitude of techniques for digital image processing. Other examples of filters that we can apply to images are, for example, those that allow us to perform [morphological transformations] (https://opencv-python-tutroals.readthedocs.io/en/latest/py_tutorials/py_imgproc/py_morphological_ops/py_morphological_ops.html)."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "kernel = np.ones((1, 1), np.uint8)\n",
    "dilation = cv2.dilate(img, kernel, iterations=1)\n",
    "\n",
    "\n",
    "fig, ax = plt.subplots(1, figsize=(5, 5))\n",
    "plt.xticks([])\n",
    "plt.yticks([])\n",
    "plt.imshow(dilation)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "<a id='image_classification_cnn'></a>\n",
    "# Image Classification CNN"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "In this section we will study the problem of classifying images with convolutional neural networks (CNN). To do this, we will rely on the [TensorFlow tutorial](https://www.tensorflow.org/tutorials/images/classification)."
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "We will start with the download of the dataset. We will work with a set of **~ 3700 photographs** of flowers from **5 different classes**."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "import pathlib\n",
    "import tensorflow as tf\n",
    "dataset_url = 'https://storage.googleapis.com/download.tensorflow.org/example_images/flower_photos.tgz'\n",
    "data_dir = tf.keras.utils.get_file('flower_photos', origin=dataset_url, untar=True)\n",
    "data_dir = pathlib.Path(data_dir)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "We check that we have all the photographs."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "image_count = len(list(data_dir.glob('*/*.jpg')))\n",
    "print(image_count)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "os.listdir(data_dir)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Visualize some of them"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "roses = list(data_dir.glob('roses/*'))\n",
    "sunflowers = list(data_dir.glob('sunflowers/*'))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "im = read_image(str(roses[np.random.randint(0, len(roses))]))\n",
    "plt.imshow(im);"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "im = read_image(str(sunflowers[np.random.randint(0, len(sunflowers))]))\n",
    "plt.imshow(im);"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "We create a TensorFlow dataset with the data that we have previously loaded to disk with the [`image_dataset_from_directory ()`](https://keras.io/api/preprocessing/image/#image_dataset_from_directory-function)\n",
    "method.\n",
    "\n",
    "The `colos_mode` parameter (by default 'rgb') allows you to choose the color scale to use. To automatically load and convert the images to grayscale it must be set as `color_mode = grayscale`."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "image_size = (96,96)\n",
    "train_ds = tf.keras.preprocessing.image_dataset_from_directory(\n",
    "  data_dir,\n",
    "  validation_split=0.2,  # 80%  train, 20% validation\n",
    "  subset='training',  # 'training' o 'validation', only  with 'validation_split'\n",
    "  seed=1,\n",
    "  image_size=image_size,  # Dimension (img_height, img_width) for rescaling\n",
    "  batch_size=64\n",
    ")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "val_ds = tf.keras.preprocessing.image_dataset_from_directory(\n",
    "  data_dir,\n",
    "  validation_split=0.2,\n",
    "  subset='validation',\n",
    "  seed=1,\n",
    "  image_size=image_size,\n",
    "  batch_size=64)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "class_names_list = train_ds.class_names\n",
    "class_names_list"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "### Configure the dataset for performance\n",
    "\n",
    "Let's make sure to use buffered prefetching so you can yield data from disk without having I/O become blocking. These are two important methods you should use when loading data.\n",
    "\n",
    "`Dataset.cache()` keeps the images in memory after they're loaded off disk during the first epoch. This will ensure the dataset does not become a bottleneck while training your model. If your dataset is too large to fit into memory, you can also use this method to create a performant on-disk cache.\n",
    "\n",
    "`Dataset.prefetch()` overlaps data preprocessing and model execution while training. \n",
    "\n",
    "Interested readers can learn more about both methods, as well as how to cache data to disk in the [data performance guide](https://www.tensorflow.org/guide/data_performance#prefetching)."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# AUTOTUNE = tf.data.AUTOTUNE\n",
    "\n",
    "# train_ds = train_ds.cache().shuffle(1000).prefetch(buffer_size=AUTOTUNE)\n",
    "# val_ds = val_ds.cache().prefetch(buffer_size=AUTOTUNE)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Visualizing some training samples."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "import matplotlib.pyplot as plt\n",
    "\n",
    "plt.figure(figsize=(10, 10))\n",
    "for images, labels in train_ds.take(1):\n",
    "    for i in range(9):\n",
    "        ax = plt.subplot(3, 3, i + 1)\n",
    "        plt.imshow(images[i].numpy().astype(\"uint8\"))\n",
    "        plt.title(class_names_list[labels[i]])\n",
    "        plt.axis(\"off\")"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "We build the model. The **input will have a dimension of (n, n, 3)**, corresponding to (image height, image width, number of color channels).\n",
    "\n",
    "At the input of the network we include a preprocessing that will allow the images to be rescaled by normalizing the pixel values to a range between 0 and 1."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "for image_batch, labels_batch in train_ds:\n",
    "    print(image_batch.shape)\n",
    "    print(labels_batch.shape)\n",
    "    break"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "import tensorflow as tf\n",
    "from tensorflow import keras\n",
    "from tensorflow.keras import layers"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## CNN model in Keras\n",
    "\n",
    "\n",
    "\n",
    "<img src=\"https://i.ibb.co/D8CmT6K/cnn.jpg\" alt=\"cnn\" border=\"0\">\n",
    "\n",
    "\n",
    "\n",
    "A Convolutional Neural Network (CNN) architecture has four main parts:\n",
    "\n",
    "- A **convolutional layer** that extracts features from a source image. \n",
    "\n",
    "- A **pooling layer** that reduces the image dimensionality without losing important features or patterns.\n",
    "\n",
    "- A **flattening layer** that transforms a n-dimensional tensor into a vector that can be fed into a fully connected neural network.\n",
    "\n",
    "- A **fully connected layer** also known as the dense layer.\n",
    "\n",
    "### Rescaling\n",
    "\n",
    "For converting the images to   \\[0,1\\] range.\n",
    "```python\n",
    "normalization_layer = layers.experimental.preprocessing.Rescaling(1./255)\n",
    "next_layer = normalization_layer(prev_layer)\n",
    "```\n",
    "or simply\n",
    "```python\n",
    "reescaling = layers.experimental.preprocessing.Rescaling(1. / 255)(inputs)\n",
    "```\n",
    "\n",
    "### Convolutional layer\n",
    "\n",
    "In the convolutional layers (`Conv2D`) we will configure the following parameters:\n",
    "\n",
    "- **filters**: number of feature maps.\n",
    "- **kernel_size**: can be either an integer or a tuple of two integers. Specifies the height and width of the kernel.\n",
    "- **padding**: allows you to include padding in the input data. With 'valid' it is not applied, with 'same' it is configured so that the dimension at the output of the convolution is the same as at the input.\n",
    "- **activation**: activation function implemented. Recommended ReLU.\n",
    "\n",
    "[Link to documentation](https://keras.io/api/layers/convolution_layers/convolution2d/)\n",
    "\n",
    "```python\n",
    "tf.keras.layers.Conv2D(\n",
    "    filters, kernel_size, strides=(1, 1), padding='valid',\n",
    "    activation=None, kernel_regularizer=None)\n",
    "\n",
    "```\n",
    "\n",
    "With Functional API:\n",
    "```python\n",
    "next_layer = layers.Conv2D(filters=8, kernel_size=3, activation='relu', name='conv_1')(prev_layer)\n",
    "```\n",
    "\n",
    "With Sequential:\n",
    "```python\n",
    "model.add(layers.Conv2D(filters=8,kernel_size=3, activation='relu', name='conv_1'))\n",
    "```\n",
    "\n",
    "### Pooling layer\n",
    "\n",
    "A pooling layer is a new layer added after the convolutional layer. Specifically, after a nonlinearity ( ReLU) you can choose between [average pooling](https://www.tensorflow.org/api_docs/python/tf/keras/layers/AveragePooling2D) or [max pooling](https://www.tensorflow.org/api_docs/python/tf/keras/layers/MaxPool2D). Usually max pooling is the best choice.\n",
    "\n",
    "\n",
    "With Functional API:\n",
    "```python\n",
    "conv_1 = layers.Conv2D(filters=8, kernel_size=3, activation='relu', name='conv_1')(prev_layer)\n",
    "\n",
    "pool_1 = layers.MaxPool2D(pool_size=(2, 2), name='pool_1')(conv_1)\n",
    "```\n",
    "\n",
    "With Sequential:\n",
    "```python\n",
    "model.add(layers.AveragePooling2D(pool_size=(2, 2), name='pool_1'))\n",
    "```\n",
    "\n",
    "### Flattening\n",
    "\n",
    "Prepares a vector for the fully connected layers.\n",
    "\n",
    "With Functional API:\n",
    "\n",
    "```python\n",
    "next_layer = layers.Flatten(name='flatten')(prev_layer)\n",
    "```\n",
    "\n",
    "With Sequential:\n",
    "```python\n",
    "model.add(layers.Flatten(name='flatten'))\n",
    "```\n",
    "\n",
    "There is another alternative for flattening that is a type of pooling that is called global pooling. Global pooling down-samples the entire feature map to a single value. \n",
    "\n",
    "You can also choose between [GlobalAveragePooling2D](https://www.tensorflow.org/api_docs/python/tf/keras/layers/GlobalAveragePooling2D) and [GlobalMaxPooling2D](https://www.tensorflow.org/api_docs/python/tf/keras/layers/GlobalMaxPool2D).\n",
    "\n",
    "```python\n",
    "model.add(layers.GlobalMaxPool2D(name='GlobalMaxPooling2D'))\n",
    "```\n",
    "\n",
    "### Fully-connected layer\n",
    "\n",
    "Dense layer like a simple neural network"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {
    "scrolled": true
   },
   "outputs": [],
   "source": [
    "inputs = tf.keras.Input(shape=image_size + (3, ), name='input')\n",
    "reescaling = layers.experimental.preprocessing.Rescaling(1. / 255)(inputs)\n",
    "\n",
    "# Conv Layer 1\n",
    "conv_1 = layers.Conv2D(4, 3, padding='valid', activation='relu',\n",
    "                       name='conv_1')(reescaling)\n",
    "pool_1 = layers.MaxPooling2D(pool_size=(2, 2), name='pool_1')(conv_1)\n",
    "\n",
    "# Conv Layer 2\n",
    "conv_2 = layers.Conv2D(4, 3, padding='valid', activation='relu',\n",
    "                       name='conv_2')(pool_1)\n",
    "pool_2 = layers.MaxPooling2D(pool_size=(2, 2), name='pool_2')(conv_2)\n",
    "\n",
    "# Conv Layer 3\n",
    "conv_3 = layers.Conv2D(4,\n",
    "                       3,\n",
    "                       padding='valid',\n",
    "                       activation='relu',\n",
    "                       name='conv_3')(pool_2)\n",
    "pool_3 = layers.MaxPooling2D(name='pool_3')(conv_3)\n",
    "\n",
    "# Fully-connected\n",
    "# Flattening\n",
    "flat = layers.Flatten(name='flatten')(pool_3)\n",
    "dense = layers.Dense(64, activation='relu', name='dense')(flat)\n",
    "outputs = layers.Dense(5, activation='softmax', name='output')(dense)\n",
    "\n",
    "model = keras.Model(inputs=inputs, outputs=outputs, name='cnn_example')"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "model.summary()"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "from tensorflow.keras.utils import plot_model\n",
    "plot_model(model, show_shapes=True)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Compile the model"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "model.compile(\n",
    "    optimizer='adam',\n",
    "    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),\n",
    "    metrics=['accuracy']\n",
    ")"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Training the model"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "epochs = 10\n",
    "history = model.fit(\n",
    "    train_ds,\n",
    "    validation_data=val_ds,\n",
    "    epochs=epochs,\n",
    ")"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Visualize the results"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "import pandas as pd\n",
    "def show_loss_accuracy_evolution(history):\n",
    "    \n",
    "    hist = pd.DataFrame(history.history)\n",
    "    hist['epoch'] = history.epoch\n",
    "\n",
    "    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 6))\n",
    "\n",
    "    ax1.set_xlabel('Epoch')\n",
    "    ax1.set_ylabel('Sparse Categorical Crossentropy')\n",
    "    ax1.plot(hist['epoch'], hist['loss'], label='Train Error')\n",
    "    ax1.plot(hist['epoch'], hist['val_loss'], label = 'Val Error')\n",
    "    ax1.grid()\n",
    "    ax1.legend()\n",
    "\n",
    "    ax2.set_xlabel('Epoch')\n",
    "    ax2.set_ylabel('Accuracy')\n",
    "    ax2.plot(hist['epoch'], hist['accuracy'], label='Train Accuracy')\n",
    "    ax2.plot(hist['epoch'], hist['val_accuracy'], label = 'Val Accuracy')\n",
    "    ax2.grid()\n",
    "    ax2.legend()\n",
    "\n",
    "    plt.show()\n",
    "\n",
    "show_loss_accuracy_evolution(history)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "#### Question 1: What happen with the validation loss and with the number of parameters if you increment the number of filters and the kernel_size ?"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "inputs = tf.keras.Input(shape=image_size + (3, ), name='input')\n",
    "reescaling = layers.experimental.preprocessing.Rescaling(1. / 255)(inputs)\n",
    "\n",
    "# Conv Layer 1\n",
    "conv_1 = layers.Conv2D(filters=..., kernel_size=..., padding='valid', activation='relu',\n",
    "                       name='conv_1')(reescaling)\n",
    "pool_1 = layers.MaxPooling2D(pool_size=(2, 2), name='pool_1')(conv_1)\n",
    "\n",
    "# Conv Layer 2\n",
    "conv_2 = layers.Conv2D(4, 3, padding='valid', activation='relu',\n",
    "                       name='conv_2')(pool_1)\n",
    "pool_2 = layers.MaxPooling2D(pool_size=(2, 2), name='pool_2')(conv_2)\n",
    "\n",
    "# Conv Layer 3\n",
    "conv_3 = layers.Conv2D(4,\n",
    "                       3,\n",
    "                       padding='valid',\n",
    "                       activation='relu',\n",
    "                       name='conv_3')(pool_2)\n",
    "pool_3 = layers.MaxPooling2D(name='pool_3')(conv_3)\n",
    "\n",
    "# Fully-connected\n",
    "# Flattening\n",
    "flat = layers.Flatten(name='flatten')(pool_3)\n",
    "dense = layers.Dense(64, activation='relu', name='dense')(flat)\n",
    "outputs = layers.Dense(5, activation='softmax', name='output')(dense)\n",
    "\n",
    "model = keras.Model(inputs=inputs, outputs=outputs, name='cnn_example')\n",
    "\n",
    "print(model.summary())\n",
    "\n",
    "model.compile(\n",
    "    optimizer='adam',\n",
    "    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),\n",
    "    metrics=['accuracy']\n",
    ")\n",
    "\n",
    "epochs = 10\n",
    "history = model.fit(\n",
    "    train_ds,\n",
    "    validation_data=val_ds,\n",
    "    epochs=epochs,\n",
    ")\n",
    "show_loss_accuracy_evolution(history)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "#### Question 2: What happen with the validation loss and with the number of parameters if you vary  the `pool_size` and the padding of the filters to `same` ?"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "inputs = tf.keras.Input(shape=image_size + (3, ), name='input')\n",
    "reescaling = layers.experimental.preprocessing.Rescaling(1. / 255)(inputs)\n",
    "\n",
    "# Conv Layer 1\n",
    "conv_1 = layers.Conv2D(filters=..., kernel_size=..., padding=..., activation='relu',\n",
    "                       name='conv_1')(reescaling)\n",
    "pool_1 = layers.MaxPooling2D(pool_size=(..., ...), name='pool_1')(conv_1)\n",
    "\n",
    "# Conv Layer 2\n",
    "conv_2 = layers.Conv2D(4, 3, padding='valid', activation='relu',\n",
    "                       name='conv_2')(pool_1)\n",
    "pool_2 = layers.MaxPooling2D(pool_size=(2, 2), name='pool_2')(conv_2)\n",
    "\n",
    "# Conv Layer 3\n",
    "conv_3 = layers.Conv2D(4,\n",
    "                       3,\n",
    "                       padding='valid',\n",
    "                       activation='relu',\n",
    "                       name='conv_3')(pool_2)\n",
    "pool_3 = layers.MaxPooling2D(name='pool_3')(conv_3)\n",
    "\n",
    "# Fully-connected\n",
    "# Flattening\n",
    "flat = layers.Flatten(name='flatten')(pool_3)\n",
    "dense = layers.Dense(64, activation='relu', name='dense')(flat)\n",
    "outputs = layers.Dense(5, activation='softmax', name='output')(dense)\n",
    "\n",
    "model = keras.Model(inputs=inputs, outputs=outputs, name='cnn_example')\n",
    "\n",
    "print(model.summary())\n",
    "\n",
    "model.compile(\n",
    "    optimizer='adam',\n",
    "    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),\n",
    "    metrics=['accuracy']\n",
    ")\n",
    "\n",
    "epochs = 10\n",
    "history = model.fit(\n",
    "    train_ds,\n",
    "    validation_data=val_ds,\n",
    "    epochs=epochs,\n",
    ")\n",
    "show_loss_accuracy_evolution(history)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "#### Question 3: Create a model with `val_accuracy > 0.72`\n",
    "\n",
    "You can use early-stopping callback and dropouts techniques.\n",
    "\n",
    "```python\n",
    "next_layer = layers.Dropout(0.4)(prev_layer)\n",
    "```\n",
    "\n",
    "```python\n",
    "next_layer = layers.BatchNormalization()(prev_layer)\n",
    "```\n",
    "\n",
    "```python\n",
    "es_callback = keras.callbacks.EarlyStopping(\n",
    "    monitor='val_loss',  # can be 'val_accuracy'\n",
    "    patience=5,  # if during 5 epochs there is no improvement in `val_loss`, the execution will stop\n",
    "    verbose=1)\n",
    "```"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "inputs = tf.keras.Input(shape=image_size + (3, ), name='input')\n",
    "reescaling = layers.experimental.preprocessing.Rescaling(1. / 255)(inputs)\n",
    "...\n",
    "outputs = layers.Dense(5, activation='softmax', name='output')(dense)\n",
    "model = keras.Model(inputs=inputs, outputs=outputs, name='cnn_example')\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "model.compile(\n",
    "    optimizer='adam',\n",
    "    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),\n",
    "    metrics=['accuracy']\n",
    ")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "es_callback = keras.callbacks.EarlyStopping(\n",
    "    monitor='val_loss',  # can be 'val_accuracy'\n",
    "    patience=4,  # if during 5 epochs there is no improvement in `val_loss`, the execution will stop\n",
    "    verbose=1)\n",
    "\n",
    "\n",
    "epochs = 25\n",
    "history = model.fit(\n",
    "    train_ds,\n",
    "    validation_data=val_ds,\n",
    "    epochs=epochs,\n",
    "    callbacks=[es_callback]\n",
    ")\n",
    "show_loss_accuracy_evolution(history)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "### Data Augmentation\n",
    "\n",
    "[**data augmentation**](https://en.wikipedia.org/wiki/Data_augmentation) We transform randomly the training images.\n",
    "\n",
    "Data augmentation can be done before starting any training directly on the available image set, or working with the [Keras layers for that purpose](https://www.tensorflow.org/tutorials/images/data_augmentation). In that example we will do it the second way by randomly rotating, flipping and scaling the images."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "data_augmentation = keras.Sequential(\n",
    "  [\n",
    "    layers.experimental.preprocessing.RandomFlip(),\n",
    "    layers.experimental.preprocessing.RandomRotation(0.25),\n",
    "    layers.experimental.preprocessing.RandomZoom(0.25),\n",
    "  ]\n",
    ")"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Some examples"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "plt.figure(figsize=(10, 10))\n",
    "for images, _ in train_ds.take(1):\n",
    "    for i in range(9):\n",
    "        augmented_images = data_augmentation(images)\n",
    "        ax = plt.subplot(3, 3, i + 1)\n",
    "        plt.imshow(augmented_images[0].numpy().astype(\"uint8\"))\n",
    "        plt.axis(\"off\")"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "We include the stage that performs the transformations in the images at the beginning of the model that we built previously, we repeat the training and visualize the results."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "inputs = tf.keras.Input(shape=image_size + (3, ), name='input')\n",
    "data_aug = data_augmentation(inputs)\n",
    "reescaling = layers.experimental.preprocessing.Rescaling(1. / 255)(data_aug)\n",
    "\n",
    "# Conv Layer 1\n",
    "conv_1 = layers.Conv2D(8, 3, padding='valid', activation='relu',\n",
    "                       name='conv_1')(reescaling)\n",
    "pool_1 = layers.MaxPooling2D(pool_size=(2, 2), name='pool_1')(conv_1)\n",
    "\n",
    "# Conv Layer 2\n",
    "conv_2 = layers.Conv2D(8, 3, padding='valid', activation='relu',\n",
    "                       name='conv_2')(pool_1)\n",
    "pool_2 = layers.MaxPooling2D(name='pool_2')(conv_2)\n",
    "\n",
    "# Conv Layer 3\n",
    "conv_3 = layers.Conv2D(8,\n",
    "                       3,\n",
    "                       padding='valid',\n",
    "                       activation='relu',\n",
    "                       name='conv_3')(pool_2)\n",
    "pool_3 = layers.MaxPooling2D(name='pool_3')(conv_3)\n",
    "\n",
    "# Fully-connected\n",
    "flat = layers.Flatten(name='flatten')(pool_3)\n",
    "dense = layers.Dense(64, activation='relu', name='dense')(flat)\n",
    "outputs = layers.Dense(5, activation='softmax', name='output')(dense)\n",
    "\n",
    "model = keras.Model(inputs=inputs, outputs=outputs, name='cnn_example')"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "es_callback = keras.callbacks.EarlyStopping(\n",
    "    monitor='val_loss',  # can be 'val_accuracy'\n",
    "    patience=10,  # if during 5 epochs there is no improvement in `val_loss`, the execution will stop\n",
    "    verbose=1)\n",
    "\n",
    "\n",
    "epochs = 10\n",
    "history = model.fit(\n",
    "    train_ds,\n",
    "    validation_data=val_ds,\n",
    "    epochs=epochs,\n",
    "    callbacks=[es_callback]\n",
    ")\n",
    "show_loss_accuracy_evolution(history)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "#### Question 4: Use the best model you have found and include the `data_aug` layer, compare the results"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "inputs = tf.keras.Input(shape=image_size + (3, ), name='input')\n",
    "data_aug = data_augmentation(inputs)\n",
    "reescaling = layers.experimental.preprocessing.Rescaling(1. / 255)(data_aug)\n",
    "..."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "es_callback = keras.callbacks.EarlyStopping(\n",
    "    monitor='val_loss',  # can be 'val_accuracy'\n",
    "    patience=10,  # if during 5 epochs there is no improvement in `val_loss`, the execution will stop\n",
    "    verbose=1)\n",
    "\n",
    "\n",
    "epochs = 150\n",
    "history = model.fit(\n",
    "    train_ds,\n",
    "    validation_data=val_ds,\n",
    "    epochs=epochs,\n",
    "    callbacks=[es_callback]\n",
    ")\n",
    "show_loss_accuracy_evolution(history)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Transfer learning\n",
    "\n",
    "With transfer learning, you benefit from both advanced convolutional neural network architectures developed by top researchers and from pre-training on a huge dataset of images. In our case we will be transfer learning from a network trained on ImageNet, a database of images containing many plants and outdoors scenes, which is close enough to flowers.\n",
    "\n",
    "<img src=\"https://i.ibb.co/KsLSGyt/transfer-learning.png\" alt=\"transfer-learning\" border=\"0\">"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "[MobileNetV2](https://arxiv.org/abs/1801.04381) is a significant improvement over MobileNetV1 and pushes the state of the art for mobile visual recognition including classification, object detection and semantic segmentation.\n",
    "\n",
    "In [`tf.keras.applications`](https://www.tensorflow.org/api_docs/python/tf/keras/applications) you have many pre-trained models. You can compare them [here](https://keras.io/api/applications/#available-models).\n",
    "\n",
    "With the parameter `include_top=False`, you can delete the last `softmax` layer.\n",
    "\n",
    "With `pretrained_model.trainable = False`, you freeze the pre-trained model weights. "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "pretrained_model = tf.keras.applications.MobileNetV2(input_shape=image_size+(3,), include_top=False)\n",
    "pretrained_model.trainable = False\n",
    "pretrained_model.summary()"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "You define your new model adding more layers"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "model_tl = tf.keras.Sequential([\n",
    "    layers.experimental.preprocessing.Rescaling(1./255),\n",
    "    pretrained_model,\n",
    "    tf.keras.layers.Flatten(),\n",
    "    tf.keras.layers.Dropout(0.5),\n",
    "    tf.keras.layers.Dense(5, activation='softmax')\n",
    "])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "model_tl.compile(\n",
    "    optimizer='adam',\n",
    "    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),\n",
    "    metrics=['accuracy']\n",
    ")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "epochs = 5\n",
    "history = model_tl.fit(\n",
    "  train_ds,\n",
    "  validation_data=val_ds,\n",
    "  epochs=epochs\n",
    ")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "show_loss_accuracy_evolution(history)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "from tensorflow.keras.utils import plot_model\n",
    "plot_model(model_tl, show_shapes=True)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "inputs = tf.keras.Input(shape=image_size+(3, ), name='input')\n",
    "\n",
    "#data_aug = data_augmentation(inputs)\n",
    "reescaling = layers.experimental.preprocessing.Rescaling(1./255)(inputs)\n",
    "\n",
    "# Conv Layer 1\n",
    "conv_1 = layers.Conv2D(8, 3, padding='valid',\n",
    "                       activation='relu', name='conv_1')(reescaling)\n",
    "pool_1 = layers.MaxPooling2D(pool_size=(\n",
    "    2, 2),  name='pool_1')(conv_1)\n",
    "\n",
    "# Conv Layer 2\n",
    "conv_2 = layers.Conv2D(8, 3, padding='valid',\n",
    "                       activation='relu', name='conv_2')(pool_1)\n",
    "pool_2 = layers.MaxPooling2D(name='pool_2')(conv_2)\n",
    "\n",
    "# Conv Layer 3\n",
    "conv_3 = layers.Conv2D(16, 3, padding='valid',\n",
    "                       activation='relu', name='conv_3')(pool_2)\n",
    "pool_3 = layers.MaxPooling2D(name='pool_3')(conv_3)\n",
    "\n",
    "# Fully-connected\n",
    "x1 = layers.Flatten(name='flatten')(pool_3)\n",
    "\n",
    "x2 = pretrained_model(reescaling, training=False)\n",
    "x2 = tf.keras.layers.Flatten()(x2)\n",
    "\n",
    "x = tf.keras.layers.Concatenate()([x1, x2])\n",
    "x = layers.Dropout(0.4)(x)\n",
    "x = layers.Dense(64, activation='relu', name='dense')(x)\n",
    "# A Dense classifier with a single unit (binary classification)\n",
    "outputs = tf.keras.layers.Dense(5, activation='softmax')(x)\n",
    "model_tl = keras.Model(inputs, outputs)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "from tensorflow.keras.utils import plot_model\n",
    "plot_model(model_tl, show_shapes=True)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "model_tl.compile(\n",
    "    optimizer='adam',\n",
    "    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),\n",
    "    metrics=['accuracy']\n",
    ")\n",
    "epochs = 5\n",
    "history = model_tl.fit(\n",
    "  train_ds,\n",
    "  validation_data=val_ds,\n",
    "  epochs=epochs\n",
    ")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": []
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "epochs = 20\n",
    "model_tl = tf.keras.Sequential([\n",
    "    data_augmentation,\n",
    "    layers.experimental.preprocessing.Rescaling(1./255),\n",
    "    tf.keras.applications.MobileNetV2(input_shape=image_size+(3, ), include_top=False),\n",
    "    tf.keras.layers.Flatten(),\n",
    "    tf.keras.layers.Dropout(0.5),\n",
    "    tf.keras.layers.Dense(5, activation='softmax')\n",
    "])\n",
    "model_tl.compile(\n",
    "    optimizer='adam',\n",
    "    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),\n",
    "    metrics=['accuracy']\n",
    ")\n",
    "history = model_tl.fit(\n",
    "  train_ds,\n",
    "  validation_data=val_ds,\n",
    "  epochs=epochs\n",
    ")"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Practice: Fashion MNIST Try to obtain  `Test Accuracy>0.89`!!\n",
    "\n",
    "Fashion MNIST dataset contains 70,000 grayscale images with 10 categories. The images show individual articles of clothing at low resolution (28 by 28 pixels).\n",
    "\n",
    "<table>\n",
    "  <tr><td>\n",
    "    <img src=\"https://tensorflow.org/images/fashion-mnist-sprite.png\"\n",
    "         alt=\"Fashion MNIST sprite\"  width=\"300\">\n",
    "  </td></tr>\n",
    "  <tr><td align=\"center\">\n",
    "    <b>Figure 1.</b> <a href=\"https://github.com/zalandoresearch/fashion-mnist\">Fashion-MNIST samples</a> (by Zalando, MIT License).<br/>&nbsp;\n",
    "  </td></tr>\n",
    "</table>\n",
    "\n",
    "**Categories**:\n",
    "<table>\n",
    "  <tr>\n",
    "    <th>Label</th>\n",
    "    <th>Class</th>\n",
    "  </tr>\n",
    "  <tr>\n",
    "    <td>0</td>\n",
    "    <td>T-shirt/top</td>\n",
    "  </tr>\n",
    "  <tr>\n",
    "    <td>1</td>\n",
    "    <td>Trouser</td>\n",
    "  </tr>\n",
    "    <tr>\n",
    "    <td>2</td>\n",
    "    <td>Pullover</td>\n",
    "  </tr>\n",
    "    <tr>\n",
    "    <td>3</td>\n",
    "    <td>Dress</td>\n",
    "  </tr>\n",
    "    <tr>\n",
    "    <td>4</td>\n",
    "    <td>Coat</td>\n",
    "  </tr>\n",
    "    <tr>\n",
    "    <td>5</td>\n",
    "    <td>Sandal</td>\n",
    "  </tr>\n",
    "    <tr>\n",
    "    <td>6</td>\n",
    "    <td>Shirt</td>\n",
    "  </tr>\n",
    "    <tr>\n",
    "    <td>7</td>\n",
    "    <td>Sneaker</td>\n",
    "  </tr>\n",
    "    <tr>\n",
    "    <td>8</td>\n",
    "    <td>Bag</td>\n",
    "  </tr>\n",
    "    <tr>\n",
    "    <td>9</td>\n",
    "    <td>Ankle boot</td>\n",
    "  </tr>\n",
    "</table>"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Load the dataset\n",
    "fashion_mnist = tf.keras.datasets.fashion_mnist\n",
    "\n",
    "(train_images, train_labels), (test_images,\n",
    "                               test_labels) = fashion_mnist.load_data()\n",
    "\n",
    "print('train_images shape: {0}, test_images shape: {1}'.format(\n",
    "    train_images.shape, test_images.shape))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "class_names = ['T-shirt/top', 'Trouser', 'Pullover', 'Dress', 'Coat',\n",
    "               'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot']"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "plt.figure(figsize=(10,10))\n",
    "for i in range(25):\n",
    "    plt.subplot(5,5,i+1)\n",
    "    plt.xticks([])\n",
    "    plt.yticks([])\n",
    "    plt.grid(False)\n",
    "    plt.imshow(train_images[i], cmap='gray')\n",
    "    plt.xlabel(class_names[train_labels[i]])\n",
    "plt.show()"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "data_augmentation = keras.Sequential(\n",
    "  [\n",
    "    layers.experimental.preprocessing.RandomFlip(),\n",
    "    layers.experimental.preprocessing.RandomRotation(0.25),\n",
    "  ]\n",
    ")\n",
    "\n",
    "data_augmentation = keras.Sequential(\n",
    "  [\n",
    "    layers.experimental.preprocessing.RandomFlip(),\n",
    "  ]\n",
    ")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "inputs = tf.keras.Input(shape=(28, 28, 1), name='input')\n",
    "#aug = data_augmentation(inputs)\n",
    "reescaling = layers.experimental.preprocessing.Rescaling(1. / 255)(inputs)\n",
    "...\n",
    "model = keras.Model(inputs=inputs, outputs=outputs, name='cnn_mnist')"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "### compile the model\n",
    "model.compile(optimizer='adam',\n",
    "              loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),\n",
    "              metrics=['accuracy'])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "### train\n",
    "model.fit(train_images, train_labels,\n",
    "          epochs=7, batch_size=32, validation_split=0.2)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "results = model.evaluate(test_images, test_labels, verbose=1)\n",
    "print('Test Loss: {}'.format(results[0]))\n",
    "print('Test Accuracy: {}'.format(results[1]))"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "### Plotting predictions"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "predictions = model.predict(test_images)\n",
    "predicted_classes = np.argmax(predictions, -1)\n",
    "predictions.shape, predicted_classes.shape\n",
    "predictions[i,:]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "L = 5\n",
    "W = 5\n",
    "fig, axes = plt.subplots(L, W, figsize=(14, 14))\n",
    "axes = axes.ravel()\n",
    "\n",
    "for i in np.arange(0, L * W):\n",
    "    axes[i].imshow(test_images[i].reshape(28, 28))\n",
    "    prob_pred = np.max(predictions[i, :])\n",
    "    class_pred = class_names[int(predicted_classes[i])]\n",
    "    original_class = class_names[int(test_labels[i])]\n",
    "    axes[i].set_title(\n",
    "        f\"Pred Class = {class_pred} \\n Target = {original_class} \\n Probability = {prob_pred:.3f}\")\n",
    "    axes[i].axis('off')\n",
    "\n",
    "plt.subplots_adjust(wspace=0.5)"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.5"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 1
}

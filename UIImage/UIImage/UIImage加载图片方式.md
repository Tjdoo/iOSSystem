## 一、创建图片对象

根据是否缓存图数据，有两类创建 UIImage 对象的方法可选：

> Use the imageNamed:inBundle:compatibleWithTraitCollection: method (or the imageNamed: method) to create an image from an image asset or image file located in your app’s main bundle (or some other known bundle). Because these methods cache the image data automatically, they are especially recommended for images that you use frequently.

1、有缓存 imageNamed: 可以加载 bundle 中任意位置的图片，包括 mainBundle 中其他 bundle 的。

imageNamed: 方法创建对象的步骤如下：

①、根据图片文件名在缓存池中查找图片数据，如果存在则创建对象并返回；

②、如果不存在，则从 bundle 中加载图片数据，创建对象并返回；

③、如果相应的图片数据不存在，返回 nil。

> Use the imageWithContentsOfFile: or initWithContentsOfFile: method to create an image object where the initial data is not in a bundle. These methods load the image data from disk each time, so you should not use them to load the same image repeatedly.

2、无缓存 imageWithContentsOfFile: 必须传入图片文件的全名（全路径＋文件名）。无法加载 Images.xcassets 中的图片。


## 二、Images.xcassets

Images.xcassets 在 app 打包后，以 Assets.car 文件的形式出现在 bundle 中。其作用在于：

①、自动识别 @2x、@3x 图片，对内容相同但分辨率不同的图片统一管理；

②、可以对图片进行 Slicing，即剪裁和拉伸；

③、只能通过 imageNamed: 方法加载图片资源，通过 NSBundle 的 pathForResource:ofType: 无法获得图片路径；

④、使用 imageNamed: 加载时，只需提供文件名，不需提供扩展名，从别的的地方加载图片，必须在文件名后加扩展名；

⑤、适合存放系统常用的、占用内存小的图片资源；

⑥、只支持 png/jpeg，不支持诸如 gif 等其他图片格式；

⑦、同名图片很有可能造成异常和 bug。如：一个在 Assets.xcassets 被 sliced，另一个没有，则系统 sliced 图片。

⑧、如果一个 sliced 过的图片连同相应的 Contents.json 一起拷贝，则处理效果会被保留。


## 三、从其他 Bundle 中加载资源

从 mainBundle 中其他 bundle 加载资源，分为四步：

①、在 mainBundle 中找到特定 bundle。

②、载入 bundle，即创建 bundle 对象。

③、从 bundle 中获取资源路径。注意，如果资源位于次级目录，则必须指明路径。

④、通过路径创建对象。


## 四、文章

[UIImage加载图片的方式以及Images.xcassets对于加载方法的影响](https://www.jianshu.com/p/5358f587af38)

[笔记@Bundle Programming Guide](https://www.jianshu.com/p/f40313d37049)
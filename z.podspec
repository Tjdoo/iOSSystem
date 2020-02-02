#
#  Be sure to run `pod spec lint podspec.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

# 项目名
  spec.name         = "podspec"
# 版本号
  spec.version      = "0.0.1"
# 简单描述
  spec.summary      = "A short description of podspec."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

# 详细介绍
  spec.description  = <<-DESC
                   DESC

# 主页，可填写项目的 github 地址，只支持 HTTP 和 HTTPS 地址，不支持 ssh 的地址
  spec.homepage     = "http://EXAMPLE/podspec"

# 截图地址
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

# license类型
  spec.license      = "MIT (example)"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

# 作者和邮箱
  spec.author             = { "dubinbin" => "dubinbin@ciyun.cn" }
  # Or just: spec.author    = "dubinbin"
  # spec.authors            = { "dubinbin" => "dubinbin@ciyun.cn" }

# 常用社交地址
  # spec.social_media_url   = "https://twitter.com/dubinbin"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

# 支持的平台及版本
  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

# 最低要求的系统版本（与s.platform效果类似）
  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

# 项目 git 地址。tag 值以 v 开头，支持子模块(子模块是git的子模块)
  spec.source       = { :git => "http://EXAMPLE/podspec.git", :tag => "#{spec.version}" }
# 项目svn地址
  spec.source = { :svn => 'http://svn.code.sf.net/p/polyclipping/code', :tag => '4.8.8' }
# 项目压缩包地址
  spec.source = { :http => 'http://dev.wechatapp.com/download/sdk/WeChat_SDK_iOS_en.zip' }
# 指定压缩包地址，并校验 hash 值，支持 sha1 和 sha256
  spec.source = { :http => 'http://dev.wechatapp.com/download/sdk/WeChat_SDK_iOS_en.zip', :sha1 => '7e21857fe11a511f472cfd7cfa2d979bd7ab7d96' }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

# 表示源文件的路径，这个路径是相对 podspec 文件而言的
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
# 排除指定文件
  spec.exclude_files = "Classes/Exclude"

# 公开的头文件。在这个属性中声明过的 .h 文件能够使用 <> 方法联想调用（这个是可选属性）
  # spec.public_header_files = "Classes/**/*.h"

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
# 资源文件
  # spec.resources = "Resources/*.png"

# 动态库所使用的资源文件存放位置
    spec.resource_bundles = { 'BasicModule' => ['/Classes/**/*.{xib,storyboard,Bundle,png,gif,jpg,jpeg,txt,js}', 'Resource/**/*'] }

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

# 建立名称为 MRCFiles 的子文件夹（虚拟路径）
    spec.subspec 'MRCFiles' do |subspec|
        subspec.requires_arc        = false
        # gcc 编译语言设置
        subspec.compiler_flags      = '-ObjC'
        subspec.source_files = [
            "MRCFiles/**/*"
        ]
    end

    spec.subspec 'prefix' do |sp|
        sp.prefix_header_file = 'Classes/Others/Base-PrefixHeader.pch'
    end

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

# 需要用到的 frameworks，不需要加 .framework 后缀
  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

# 需要用到的.a库，不需要添加后缀
  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

# 第三方动态、静态库
    spec.ios.vendored_frameworks = "Classes/**/*.framework", "Private/**/*.framework"
    spec.ios.vendored_libraries = "Classes/**/*.a", "Private/**/*.a"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

# 是否是 ARC，默认 true，如果不是，会自动添加 -fno-objc-arc compiler flag
  # spec.requires_arc = true
    spec.requires_arc = false
    spec.requires_arc = 'Classes/Arc'   // 该文件夹下是 ARC，其它非 ARC
    spec.requires_arc = ['Classes/*ARC.m', 'Classes/ARC.mm']


# 设置 target 项中的 build settings 配置信息
  # spec.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC', "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

# 设置 pod target 项中的 build settings 配置信息（效果与 xcconfig 类似）
  # pod_target_xcconfig = {}

# 依赖关系，该项目所依赖的其他库 （理解上来说是先 pod 指定库，然后配置 build phases 的 target-dependecies 和 link binary with liabraries）
  # spec.dependency "JSONKit", "~> 1.4"
  # spec.dependency 'AFNetworking', '~> 3.2.1'
# 依赖私有库
  # spec.dependency 'MyMediator'
# 指定某个平台的依赖
  # spec.ios.dependency 'MBProgressHUD', '~> 0.5'

# 为库配置 pch 文件并引用
  # prefix_header_contents = '#import "AHeader.h"','#import "BHeader.h"';

# 在pod文件下载完毕之后执行的命令
# 单条命令
  # spec.prepare_command = 'ruby build_files.rb'
#
    spec.prepare_command = <<-CMD
                            sed -i 's/MyNameSpacedHeader/Header/g' ./**/*.h
                            sed -i 's/MyNameOtherSpacedHeader/OtherHeader/g' ./**/*.h
                            CMD

# 是否过期
    spec.deprecated = true

end

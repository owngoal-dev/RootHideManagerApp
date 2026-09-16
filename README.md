# RootHide Manager

iOS 15+。Swift/UIKit 界面，保留 Objective-C 系统接口和清理规则引擎。

应用名单支持搜索、刷新、开关和长按／侧滑清除应用数据；开关保存仅更新对应应用。

“var 清理”检查指定路径中可能被 App 识别为越狱特征的文件，供用户确认用途后按需移除。保留规则优先级、手动选择、批量选择、Filza 和复制路径；移除前确认，后台执行，失败项目保留供重试。

启动前同步准备首屏数据，不展示转圈页或淡入过渡。启动检查汇总到黑名单页的“环境检查”，摘要直接列出发现项，详情支持下拉刷新，不再逐项弹窗。设置保留自定义清理规则和关于区域，移除“通用”和原已禁用的“白名单模式”。

## 构建与检查

建议使用 Xcode 16 或更新版本打开 `RootHide.xcodeproj`。真实功能依赖设备上的 RootHide 环境及原有权限；普通模拟器不具备这些系统接口。

```sh
# 无需 Theos：格式化、严格检查和非破坏性回归检查
make format
make format-check
make check

# 未签名真机构建
xcodebuild -project RootHide.xcodeproj -scheme RootHide \
  -configuration Release -sdk iphoneos -destination 'generic/platform=iOS' \
  CODE_SIGNING_ALLOWED=NO ARCHS='arm64 arm64e' build

# 配置好包含 roothide package scheme 的 Theos 和签名工具后打包
make THEOS="$HOME/theos-roothide" package
```

`make format` 合并 Xcode 自带的 `swift-format` 与 `clang-format`，后者须在 PATH 中（可用 `brew install clang-format` 安装）。可通过 `SWIFT_FORMAT`、`CLANG_FORMAT` 覆盖命令。第三方 JSON 注释解析器及 RootHide 头文件不批量改写。

`make check` 需要 Python 3 和 Xcode 命令行工具，验证八语言翻译覆盖及参数一致性、环境摘要的分组与简写、服务端口配置的读写与校验、清理规则优先级和选择恢复、内置规则 CRC；不执行清理操作。修改 `VarCleanRules.json` 后需同步更新 `VarCleanRules.h`，Theos 的 `before-all` 会自动生成该校验值。

本地化集中于 `RootHide/Localizable.xcstrings`：英语、简体中文、日语、德语、法语、意大利语、阿拉伯语、越南语。旧配置文件路径及格式保持兼容。

## 图标

重绘源图为 `RootHide/Assets.xcassets/AppIcon.appiconset/icon-1024.png`，已生成全部 iPhone/iPad 图标尺寸。通过内置 ImageGen 生成，再用系统 `sips` 缩放；设置页使用同源 `BrandIcon`。

生成提示：保留原有深色背景、带叶片的咬痕苹果轮廓、右半白色与左半彩色终端纹理、左下至右上的细斜向棱彩分割线。简化终端字符为稀疏的绿、黄、珊瑚红和紫色横向符号；边缘清晰、缩小后易辨认；不添加文字、边框、圆角或其他图形。

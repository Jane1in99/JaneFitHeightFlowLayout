
# JaneFitHeightFlowLayout

自适应高度瀑布流列表布局

## Installation

CocoaPods【使用CocoaPods】

```bash
  pod 'JaneFitHeightFlowLayout'
```

Manually【手动导入】

```bash
  - Drag the ‘JaneFitHeightFlowLayout’ file from the project directory into your project【将项目目录下JaneFitHeightFlowLayout文件夹拽入你的项目中】
  - Import the main header file：#import "JaneFitHeightFlowLayout.h"【导入主头文件：#import "JaneFitHeightFlowLayout.h"】 
  - The Swift project requires the use of bridging to import header files【swift项目需要使用桥接导入头文件】
```
    
## Usage/Examples

```swift
import JaneFitHeightFlowLayout

let layout = JaneFitHeightFlowLayout()
layout.delegate = self //实现代理
let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
...

再实现JaneFitHeightFlowLayoutDelegateDelegate
extension ViewController: JaneFitHeightFlowLayoutDelegate {
    
  func flowLayout(_ layout: JaneFitHeightFlowLayout!, heightForItemAt indexPath: IndexPath!, with itemWidth: CGFloat) -> CGFloat {
      return arr[indexPath.item]
  }

  ...
}

```


## Screenshots

![App Screenshot](https://github.com/Jane1in99/JaneFitHeightFlowLayout/main/images/screenshot.png)


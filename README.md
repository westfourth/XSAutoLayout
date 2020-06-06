# XSAutoLayout

最简要的自动布局

## 为什么重复造轮子

简单、方便、公式化，只有一个接口。

## 使用

### 1. view1与父视图左右上下都是20。

``` objc
lay(view1.left, nil, 1, 20);
lay(view1.right, nil, 1, -20);
lay(view1.top, nil, 1, 20);
lay(view1.bottom, nil, 1, -20);
```

### 2. view1在父视图中央。

``` objc
lay(view1.centerX, nil, 1, 0);
lay(view1.centerY, nil, 1, 0);
```

### 3. view2在view1的右侧20个点、水平对齐、与view1等高，宽度是view1的2倍。

``` objc
lay(view2.left, view1.right, 1, 20);
lay(view2.centerY, view1.centerY, 1, 0);
lay(view2.height, view1.height, 1, 0);
lay(view2.width, view1.width, 2, 0);
```

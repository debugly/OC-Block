> Objective-C 语言一直以来由苹果公司维护着，为其增加了不少更加现代化的语法，其中 block （其他语言一般都称闭包）语法就是在 iOS 4 发布的，与此同时还提供了抽象程度极高的GCD 技术，用于简化线程的操作！所以今天说的 block 并不是新的技术，但它恐怕是最难记忆的的语法了，并且使用形式很是灵活，因此总结一下我平时使用的几种类型，供大家参考。

可下载该 [demo](https://github.com/debugly/OC-Block) 来帮助理解。

### 1.描述为属性
	
这是最为常见的用法了，一般都是先赋值，当触发某个逻辑时进行回调；
	
```
@property (nonatomic, copy) returnType (^blockName)(parameterTypes);
self.blockName = ...;//赋值一个block
self.blcokName(parameters);//调用
```
	
### 2.作为形参(parameter)，做回调

a.经常和属性配合使用；一般场景是方法内部有异步执行的任务，执行完毕后通过这个block参数回调到调用处；
	
```
 - (void)doSomeThingWithCompletion:(retunType (^)(parameterTypes))blockName{
	async(...{
	    blockName(parameters);
	});
 }
```

b.相当于写个 setter 方法，给 block 属性赋值，直接给属性赋值的话需要手写实现 block ，不容易记，这其实是为了方便调用者而已。

```
 - (void)registerXXXHandler:(void (^)(float))handler
{
    self.xxxHandler = handler;
}
```

### 3.作为实参(argument)，实现block

调用一个带有 block 参数的方法时，就需要实现这个 block 了，其实这个不用手写，IDE 会提示的，直接回车即可；
	
```
[self doSomeThingWithCompletion: ^retunType(parameters){
//...
}];
```
### 4. typedef 出"新类型"

以上使用一点也不友好，所以基本上我们都会使用 typedef 定义一个类型出来；

```
typedef returnType(^ TypeName)(parameterTypes) 
//以上用法可改为：
@property (nonatomic, copy) TypeName blockName;
- (void)doSomeThingWithCompletion:(TypeName)blockName;
```

### 5.方法内部当局部变量使用

如果一段代码里有很多个 if else 分支，某些分支的处理完全一样时，可将他们封装到一个block块里面；可以省去写相同代码的麻烦，也不必开辟一个新的方法；
	
```
 returnType (^blcokNmae)(parameterTypes) = ^returnType(parameters){ ... };
 //调用：
 returnType result = blcokNmae(parameters);
```

### 6.方法返回值

这种情况不太多，比如可用于实现链式编程；

```
//声明
- (returnType (^) parameterTypes) method;
//实现
- (returnType (^) parameterTypes) method{
	return ^ returnType (parameters){
		//...
		return obj;//obj 是 returnType 类型
	};
}
```

举个例子：

```
///设置url
- (SLNetworkRequest *(^)(NSString *url))c_URL;

- (SLNetworkRequest *(^)(NSString *url))c_URL
{
    return ^ SLNetworkRequest * (NSString *url){
        self.urlString = url;
        return self;
    };
}

```

### 7.高阶 Block : 作为另一个Block的参数

这种情况用的不是太多，但是一旦有需要双向交互的场景时，优势就很明显了！具体可看 demo 实现的 3G 网络询问用户是否下载的场景：

```
typedef returnType(^ Block1)(parameterTypes) 
typedef returnType(^ Block2)(parameterTypes, Block1) //Block1作为Block2的参数部分
```

可实现双向通信，比如：

```
- (void)doSomeThingWithCompletion:(Block2)blockName
{
	async(...{
		 Block1 block1 = ^(isOk){
			 if(isOK){
		    	//start download...
		    }else{
		    	//cancel something...
		    }
		 };
		 blockName(parameters, block1);
	});
}

调用：
[self doSomeThingWithCompletion: ^ returnType(parameters, block1){
	//内部处理完毕后，回调到此；
	//根据结果（parameters）做相应的逻辑，然后将处理结果再次回调到方法内部
	if(parameters){
		block1(NO);//通过block1再次回调回去告知可以进行下一步了
	}else{
		block1(YES);//通过block1再次回调回去告知不能继续
	}
}];
```

最近我制定了 H5-Native 的交互方案，编写交互需要注入的 js 脚本，通信 API 也是双向的，其原理就是 block (闭包)的嵌套使用；API 出来后 H5 和 Native 的开发同事们都很 Happy 呢！


**如果你有其他有趣的使用方法，请提供给我吧！**

前五个算是翻译，不过也确实是工作中经常用的，原文地址 : [http://fuckingblocksyntax.com](http://fuckingblocksyntax.com)

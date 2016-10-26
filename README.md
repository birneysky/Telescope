### Netty 的 ProtobufVarint32LengthFieldPrepender 粘包拆包处理
处理方式：在数据包前加入该数据包的长度标示，该标示所占字节数为1--4个字节
`长度标示` 的占用的字节数是根据具体长度确定的，
###### 1 计算长度标示长度
    
|    移位    |  值 (二进制) 0   |        1        |       2         |       3         |   值（16进制）    |
|-----------|-----------------|-----------------|-----------------|-----------------|-----------------|
| << 0      | 1 1 1 1 1 1 1 1 | 1 1 1 1 1 1 1 1 | 1 1 1 1 1 1 1 1 | 1 1 1 1 1 1 1 1 | 0X FF FF FF FF  |                  
| << 7      | 1 1 1 1 1 1 1 1 | 1 1 1 1 1 1 1 1 | 1 1 1 1 1 1 1 1 | 1 0 0 0 0 0 0 0 | 0X FF FF FF 80  |
| << 14     | 1 1 1 1 1 1 1 1 | 1 1 1 1 1 1 1 1 | 1 1 0 0 0 0 0 0 | 0 0 0 0 0 0 0 0 | 0X FF FF C0 00  |
| << 21     | 1 1 1 1 1 1 1 1 | 1 1 1 0 0 0 0 0 | 0 0 0 0 0 0 0 0 | 0 0 0 0 0 0 0 0 | 0X FF E0 00 00  |
| << 28     | 1 1 1 1 0 0 0 0 | 0 0 0 0 0 0 0 0 | 0 0 0 0 0 0 0 0 | 0 0 0 0 0 0 0 0 | 0x F0 00 00 00  |

     
     - (NSInteger) computeByteSizeForInt32:(int32_t) value{
    		if ((value & (0xffffffff <<  7)) == 0) {
            	return 1;
        	}
        	if ((value & (0xffffffff << 14)) == 0) {
            	return 2;
        	}
        	if ((value & (0xffffffff << 21)) == 0) {
            	return 3;
        	}
        	if ((value & (0xffffffff << 28)) == 0) {
            	return 4;
        	}
        	return 5;
        }
      
      
      
###### 2 根据`长度标示的字节长度` 在相应的内存范围内写入数据包的长度。（此处的写入方式，跟我所想不太一样）
如下是java 代码描述的逻辑：
    
     while (true) {
            if ((value & ~0x7F) == 0) {
                out.writeByte(value);
                return;
            } else {
                out.writeByte((value & 0x7F) | 0x80); //保持每个字节的最高位总是1
                value >>>= 7;
            }
        }
         
        
  *** `>>`  左端补齐的是最高位的符号位 ***
      
      eg:
         
        9   ---> 00000000 00000000 00000000 00000100
      	>>1 ---> 00000000 00000000 00000000 00000100
      	
    	-9  ---> 11111111 11111111 11111111 11110111
    	>>1 ---> 11111111 11111111 11111111 11111011
      
  *** `>>>`  java中表示，向右移位，左端补齐的`0`,对于正数来说等价于`>>`,对于负数来说是不同的 ***
  
      eg:
      
        9    ---> 00000000 00000000 00000000 00000100
      	>>>1 ---> 00000000 00000000 00000000 00000100
       
  		-9  ---> 11111111 11111111 11111111 11110111
       >>>1 ---> 01111111 11111111 11111111 11111011
                 
  
  0x7F  ---->   0111 1111
  
  ~0x7F ---->   1000 0000
  
  0x80  ---->   1000 0000
  
  如果value只用一个字节就可以表示，那么 value & 1000 0000  必然等于0  这种情况value 就表示数据包的长度。否则 
  假设 
      
      value = 129       ----> 0000 0000 1000 0001;
      value & 1000 0000 ----> 1000 0000;  不等于0
      
      (value & 0111 1111) | 1000 0000 --> 1000 0001;   写入
      
      1000 001 >>> 7  --->  0000 0001 -->  下一次循环
      
      value = 1  ---> 0000 0001
      value & 1000 0000 ---> 0000 0000  等于0，把value 写入
      
      最后数据写入两个字节
      1000 0001 0000 0001
      
      
### Netty ProtobufVarint32FrameDecoder  读取长度标示时的处理

* 以  129 为例 
	根据上面分析，129 被发送时，处理为  1000 0001 0000 0001  总共占用两个字节
	首先读取第一个字节 int8_t temp = 1000 0001   再有符号数中 改制为 -127
	如果读取到的第一个字节为负数，那么 int result = 1000 0001 & 0111 1111(127) = 0000 0001
	这时再读取一个字节 temp = 0000 0001;如果 temp >= 0  result = result | (temp << 7) 
	---> 0000 00001 << 7 = 0100 0000 --> 0000 0001 | 1000 0000 = 1000 0001 = 129 
	
	
	
###  Objective-C环境的protobuf 使用
参考
http://www.vviicc.com/blog/use-of-protobuf-3-0-0-for-objective-c/
	
###  参考博客
    http://blog.sunnyxx.com/2015/06/12/objc-new-features-in-2015/     
    http://mobile.51cto.com/hot-404891.htm
    
    //基础知识
    http://mobile.51cto.com/hot-404891.htm
    http://blog.sunnyxx.com/2015/06/12/objc-new-features-in-2015/
    http://wxgbridgeq.github.io/blog/2015/07/09/effective-oc-note-second/
    http://www.jianshu.com/p/9368ce9bb8f9
    
    //多线程
    http://www.jianshu.com/p/2de9c776f226
    http://www.jianshu.com/p/813f7d58935d
    https://blog.cnbluebox.com/blog/2014/07/01/cocoashen-ru-xue-xi-nsoperationqueuehe-nsoperationyuan-li-he-shi-yong/
    http://blog.csdn.net/kiki1985/article/details/8734999
    http://www.jianshu.com/p/fe1fec3d198f
    
    //直播
    http://www.cnblogs.nbhczl.com/oldmanlv/p/5625923.html
    
    //开源总结
    http://www.bigcode.top/ios-mac-open-source-projects-libraries-and-learning-blog-information/
    
    
### Xcode最常用的快捷键整理
    
    http://www.jianshu.com/p/2b5ece8e1602
     
### github上关于iOS的各种开源项目集合
    
    http://blog.csdn.net/shaobo8910/article/details/52347215
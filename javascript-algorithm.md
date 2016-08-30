# 折半查找算法

```
var data = [3, 12];
var goal = 3;

function bSearch(goal, array, indexStart, indexEnd) {
    
    if (indexStart > indexEnd) {
        return -1;
    }
    
    // 这里是关键, 不能(indexEnd+indexStart)/2 有溢出风险
    var mid = indexStart + Math.floor((indexEnd - indexStart)/2, 10);
    
    if (array[mid] === goal) {
        return mid;
    }

     if (goal > array[mid]) {
        
         // indexStart = mid+1 很重要， 
         // 不能是indexStart = mid,
         // 用于开头 indexStart > indexEnd 跳出判断。
         indexStart = mid + 1; 
     }
     else if (array[mid] > goal) {
         
         // mid-1 同上
         indexEnd = mid - 1; 
     }

     return bSearch(goal, array, indexStart, indexEnd);
}

console.log(bSearch(goal, data, 0, data.length - 1));


```
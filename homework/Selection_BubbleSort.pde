/*int[] arr={20,12,32,9};

void setup() {
  int i,j,max,index,tmp;
  for(i=0;i<arr.length;i++) {
    print(arr[i]," ");
    }
    println();
    for(i=0;i<arr.length-1;i++) {
      max=index=-1;
      for(j=0;j<arr.length-i;j++) {
        if(max<arr[j]) {
        index=j;
        max=arr[j];
      }
    }
    tmp = arr[arr.length-1-i];
    arr[arr.length-1-i]=arr[index];
    arr[index]=tmp;
  }
  for(i=0;i<arr.length;i++) {
    print(arr[i]+" ");
  }
}*/
int[] arr = {20, 12, 32, 9};

void setup() {
  int i, j, tmp;
  
  for (i=0;i<arr.length;i++) {
    print(arr[i]+" ");
  }
  println();
  for(i=0;i<arr.length-1;i++) {
    for(j=0;j<arr.length-1-i;j++) {
      if(arr[j]>arr[j+1]) {
        tmp= arr[j];
        arr[j]=arr[j+1];
        arr[j+1]=tmp;
      }
    }
  }
  for(i=0;i<arr.length;i++) {
    print(arr[i]+" ");
  }
}

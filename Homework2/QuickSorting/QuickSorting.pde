int[] arr;

void setup() {
  intArr(16);
  printArr();
  quickSort(0, arr.length - 1);
  printArr();
}

void intArr(int n) {
  int i;
  arr = new int[n];
  for(i=0; i<arr.length; i++) {
    arr[i] = (int) random(100);
  }
}

void printArr() {
  int i;
  for(i=0; i<arr.length; i++) {
    print(arr[i], " ");
  }
  println();
}

void quickSort(int low, int high) {
  if (low < high) {
    int pi = partition(low, high);
    quickSort(low, pi - 1);
    quickSort(pi + 1, high);
  }
}

int partition(int low, int high) {
  int pivot = arr[high];
  int i = (low - 1);

  for (int j = low; j < high; j++) {
    if (arr[j] <= pivot) {
      i++;
      int tmp = arr[i];
      arr[i] = arr[j];
      arr[j] = tmp;
    }
  }

  int tmp = arr[i + 1];
  arr[i + 1] = arr[high];
  arr[high] = tmp;

  return i + 1;
}

void draw() {
}

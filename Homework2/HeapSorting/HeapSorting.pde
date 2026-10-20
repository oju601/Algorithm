int[] arr;

void setup() {
  intArr(16);
  printArr();
  heapSort();
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

void heapSort() {
  int n = arr.length;

  for (int i = n / 2 - 1; i >= 0; i--) {
    heapify(n, i);
  }

  for (int i = n - 1; i > 0; i--) {
    int tmp = arr[0];
    arr[0] = arr[i];
    arr[i] = tmp;

    heapify(i, 0);
  }
}

void heapify(int n, int i) {
  int largest = i;
  int l = 2 * i + 1;
  int r = 2 * i + 2;

  if (l < n && arr[l] > arr[largest]) {
    largest = l;
  }

  if (r < n && arr[r] > arr[largest]) {
    largest = r;
  }

  if (largest != i) {
    int tmp = arr[i];
    arr[i] = arr[largest];
    arr[largest] = tmp;

    heapify(n, largest);
  }
}

void draw() {
}

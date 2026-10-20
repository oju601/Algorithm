int n = 16;
int[] arr;

// 정렬 상태를 추적하기 위한 변수
int i = 0;
int j = 0;
int maxIndex = 0;

// 제어 변수
boolean isPlaying = false;
boolean isDone = false;

void setup() {
  size(800, 600);
  frameRate(15); // 애니메이션 속도 조절
  initArray();
}

void initArray() {
  arr = new int[n];
  for (int k = 0; k < n; k++) {
    arr[k] = (int) random(100);
  }
  i = 0;
  j = 0;
  maxIndex = 0;
  isDone = false;
  isPlaying = false;
}

void draw() {
  background(32);
  drawArray();

  if (isPlaying && !isDone) {
    selectionSortStep();
  }
}

void selectionSortStep() {
  // 선택 정렬의 1단계를 프레임 단위로 실행
  if (i < n - 1) {
    if (j < n - i) {
      // 현재 값과 최댓값을 비교
      if (arr[j] > arr[maxIndex]) {
        maxIndex = j;
      }
      j++;
    } else {
      // 내부 루프가 끝나면 스왑(이동) 수행
      int tmp = arr[n - i - 1];
      arr[n - i - 1] = arr[maxIndex];
      arr[maxIndex] = tmp;

      // 다음 외부 루프 단계로 이동
      i++;
      j = 0;
      maxIndex = 0;
    }
  } else {
    isDone = true;
    isPlaying = false;
  }
}

void drawArray() {
  float mx = 20., my = 20.;
  float dx = (width - 2 * mx) / n;
  float dy = (height - 2 * my) / 100;

  for (int k = 0; k < n; k++) {
    // 색상 구분을 통한 시각적 표시
    if (isDone) {
      fill(100, 255, 100); // 정렬 완료 (초록색)
    } else if (k >= n - i) {
      fill(100, 255, 100); // 확정된 자리 (초록색)
    } else if (k == maxIndex) {
      fill(255, 50, 50);   // 현재 탐색 범위 내 최댓값 (빨간색)
    } else if (k == j && isPlaying) {
      fill(255, 255, 50);  // 현재 비교 중인 대상 (노란색)
    } else {
      fill(255);           // 미정렬 기본 상태 (흰색)
    }

    rect(mx + dx * k, height - dy * arr[k] - my, dx, dy * arr[k]);
  }

  // 조작법 텍스트 출력
  fill(255);
  textSize(20);
  text("Start: 'S'  |  Stop: 'P'  |  Reset: 'R'", 20, 40);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    isPlaying = true;
  } else if (key == 'p' || key == 'P') {
    isPlaying = false;
  } else if (key == 'r' || key == 'R') {
    initArray();
  }
}

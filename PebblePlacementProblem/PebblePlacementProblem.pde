int cols = 8;
int rows = 3;
int[][] grid;
int[][] dp;
int[][] parent;
int[] bestPattern;
int maxScore;
int[][] patterns = {
  {1, 0, 0},
  {0, 1, 0},
  {0, 0, 1},
  {1, 0, 1}
};
String[] patternNames = {"P1 (1)", "P2 (2)", "P3 (3)", "P4 (1,3)"};

void setup() {
  size(900, 620);
  textAlign(CENTER, CENTER);
  initProblem();
}

void draw() {
  background(245);
  drawGrid();
  drawDPTable();
  fill(20);
  textSize(18);
  text("Max Score: " + maxScore + "   |   Click to regenerate", width / 2, 35);
}

void mousePressed() {
  initProblem();
}

void initProblem() {
  grid = new int[rows][cols];
  dp = new int[4][cols];
  parent = new int[4][cols];
  bestPattern = new int[cols];

  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      grid[r][c] = int(random(-10, 21));
    }
  }

  solveDP();
}

int getColScore(int c, int p) {
  int sum = 0;
  for (int r = 0; r < rows; r++) {
    if (patterns[p][r] == 1) {
      sum += grid[r][c];
    }
  }
  return sum;
}

boolean isCompatible(int p1, int p2) {
  for (int r = 0; r < rows; r++) {
    if (patterns[p1][r] == 1 && patterns[p2][r] == 1) {
      return false;
    }
  }
  return true;
}

void solveDP() {
  for (int p = 0; p < 4; p++) {
    dp[p][0] = getColScore(0, p);
    parent[p][0] = -1;
  }

  for (int c = 1; c < cols; c++) {
    for (int p = 0; p < 4; p++) {
      dp[p][c] = -1000000;
      int score = getColScore(c, p);
      for (int prev = 0; prev < 4; prev++) {
        if (isCompatible(prev, p)) {
          if (dp[prev][c - 1] + score > dp[p][c]) {
            dp[p][c] = dp[prev][c - 1] + score;
            parent[p][c] = prev;
          }
        }
      }
    }
  }

  int bestLast = 0;
  for (int p = 1; p < 4; p++) {
    if (dp[p][cols - 1] > dp[bestLast][cols - 1]) {
      bestLast = p;
    }
  }

  maxScore = dp[bestLast][cols - 1];
  int curr = bestLast;
  for (int c = cols - 1; c >= 0; c--) {
    bestPattern[c] = curr;
    curr = parent[curr][c];
  }
}

void drawGrid() {
  int cellW = 90;
  int cellH = 65;
  int startX = 130;
  int startY = 75;

  fill(50);
  textSize(14);
  text("Input Grid", 65, startY + (rows * cellH) / 2);

  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      int x = startX + c * cellW;
      int y = startY + r * cellH;
      boolean hasPebble = patterns[bestPattern[c]][r] == 1;

      stroke(180);
      fill(255);
      rect(x, y, cellW, cellH);

      if (hasPebble) {
        noStroke();
        fill(70, 140, 230, 180);
        ellipse(x + cellW / 2, y + cellH / 2, 48, 48);
        fill(255);
      } else {
        fill(30);
      }

      textSize(16);
      text(grid[r][c], x + cellW / 2, y + cellH / 2);
    }
  }
}

void drawDPTable() {
  int cellW = 90;
  int cellH = 55;
  int startX = 130;
  int startY = 320;

  fill(50);
  textSize(14);
  text("DP Table", 65, startY - 25);

  for (int c = 0; c < cols; c++) {
    fill(80);
    text("Col " + c, startX + c * cellW + cellW / 2, startY - 20);
  }

  for (int p = 0; p < 4; p++) {
    fill(50);
    textSize(13);
    text(patternNames[p], 65, startY + p * cellH + cellH / 2);

    for (int c = 0; c < cols; c++) {
      int x = startX + c * cellW;
      int y = startY + p * cellH;
      boolean isOptimal = bestPattern[c] == p;

      stroke(180);
      if (isOptimal) {
        fill(255, 230, 130);
      } else {
        fill(250);
      }
      rect(x, y, cellW, cellH);

      fill(20);
      textSize(15);
      text(dp[p][c], x + cellW / 2, y + cellH / 2);
    }
  }
}

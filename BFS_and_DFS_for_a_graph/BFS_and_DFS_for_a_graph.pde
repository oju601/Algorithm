int n = 8;
int[] nodeX = {310, 180, 440, 110, 250, 370, 510, 180};
int[] nodeY = {125, 225, 225, 355, 355, 355, 355, 495};
int[][] adj = {
  {1, 2},
  {0, 3, 4},
  {0, 5, 6},
  {1, 7},
  {1, 7},
  {2, 6},
  {2, 5},
  {3, 4}
};

boolean isBFS = true;
int startNode = 0;
int currentNode = -1;
boolean finished = false;
boolean[] visited;
boolean[] inStructure;
int[] parent;
ArrayList<Integer> structure;
ArrayList<Integer> visitOrder;

int btnX = 635;
int btnY = 525;
int btnW = 200;
int btnH = 40;

void setup() {
  size(900, 620);
  textAlign(CENTER, CENTER);
  resetTraversal();
}

void draw() {
  background(245);
  drawHeader();
  drawGraphPanel();
  drawStatePanel();
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    isBFS = true;
    resetTraversal();
  } else if (key == 'd' || key == 'D') {
    isBFS = false;
    resetTraversal();
  } else if (key == 'r' || key == 'R') {
    resetTraversal();
  } else if (key == ' ') {
    stepTraversal();
  }
}

void mousePressed() {
  if (mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= btnY && mouseY <= btnY + btnH) {
    stepTraversal();
    return;
  }

  for (int i = 0; i < n; i++) {
    if (dist(mouseX, mouseY, nodeX[i], nodeY[i]) <= 24) {
      startNode = i;
      resetTraversal();
      return;
    }
  }
}

void resetTraversal() {
  visited = new boolean[n];
  inStructure = new boolean[n];
  parent = new int[n];
  for (int i = 0; i < n; i++) {
    parent[i] = -1;
  }
  structure = new ArrayList<Integer>();
  visitOrder = new ArrayList<Integer>();
  currentNode = -1;
  finished = false;

  structure.add(startNode);
  inStructure[startNode] = true;
  if (isBFS) {
    visited[startNode] = true;
  }
}

void stepTraversal() {
  if (isBFS) {
    stepBFS();
  } else {
    stepDFS();
  }
}

void stepBFS() {
  if (structure.isEmpty()) {
    currentNode = -1;
    finished = true;
    return;
  }

  int curr = structure.remove(0);
  inStructure[curr] = false;
  currentNode = curr;
  visitOrder.add(curr);

  for (int next : adj[curr]) {
    if (!visited[next]) {
      visited[next] = true;
      inStructure[next] = true;
      parent[next] = curr;
      structure.add(next);
    }
  }
}

void stepDFS() {
  if (structure.isEmpty()) {
    currentNode = -1;
    finished = true;
    return;
  }

  int curr = structure.remove(structure.size() - 1);
  inStructure[curr] = false;
  visited[curr] = true;
  currentNode = curr;
  visitOrder.add(curr);

  for (int i = adj[curr].length - 1; i >= 0; i--) {
    int next = adj[curr][i];
    if (!visited[next]) {
      if (inStructure[next]) {
        structure.remove((Integer) next);
      }
      inStructure[next] = true;
      parent[next] = curr;
      structure.add(next);
    }
  }
}

void drawHeader() {
  String modeText = isBFS ? "Mode: BFS (Queue)" : "Mode: DFS (Stack)";
  fill(20);
  textSize(17);
  text(modeText + "  |  Start: " + startNode + "  |  [B] BFS  [D] DFS  [SPACE] Step  [R] Reset", width / 2, 35);
}

void drawGraphPanel() {
  stroke(200);
  strokeWeight(1);
  fill(255);
  rect(40, 70, 540, 515, 8);

  for (int u = 0; u < n; u++) {
    for (int v : adj[u]) {
      if (u < v) {
        boolean isTreeEdge = (parent[v] == u) || (parent[u] == v);
        if (isTreeEdge) {
          stroke(70, 140, 230);
          strokeWeight(4);
        } else {
          stroke(190);
          strokeWeight(2);
        }
        line(nodeX[u], nodeY[u], nodeX[v], nodeY[v]);
      }
    }
  }

  for (int i = 0; i < n; i++) {
    strokeWeight(2);
    if (i == currentNode) {
      stroke(200, 80, 20);
      fill(255, 140, 60);
    } else if (inStructure[i]) {
      stroke(200, 160, 40);
      fill(255, 230, 130);
    } else if (visited[i]) {
      stroke(40, 100, 190);
      fill(70, 140, 230);
    } else {
      stroke(120);
      fill(255);
    }
    ellipse(nodeX[i], nodeY[i], 46, 46);

    if (i == currentNode || (visited[i] && !inStructure[i])) {
      fill(255);
    } else {
      fill(20);
    }
    textSize(16);
    text(i, nodeX[i], nodeY[i]);
  }

  drawLegend();
}

void drawLegend() {
  int y = 558;
  int[] xs = {105, 225, 355, 475};
  String[] labels = {"Unvisited", "In Queue/Stack", "Current", "Visited"};
  color[] fills = {color(255), color(255, 230, 130), color(255, 140, 60), color(70, 140, 230)};

  textSize(12);
  for (int i = 0; i < 4; i++) {
    stroke(120);
    strokeWeight(1);
    fill(fills[i]);
    ellipse(xs[i] - 35, y, 14, 14);
    fill(50);
    text(labels[i], xs[i] + 15, y);
  }
}

void drawStatePanel() {
  stroke(200);
  strokeWeight(1);
  fill(255);
  rect(605, 70, 260, 235, 8);
  rect(605, 320, 260, 265, 8);

  fill(30);
  textSize(15);
  text(isBFS ? "Queue (Front -> Rear)" : "Stack (Top -> Bottom)", 735, 95);

  if (structure.isEmpty()) {
    fill(140);
    textSize(14);
    text(finished ? "Completed" : "Empty", 735, 185);
  } else {
    int count = structure.size();
    for (int i = 0; i < count; i++) {
      int val = isBFS ? structure.get(i) : structure.get(count - 1 - i);
      int y = 125 + i * 28;
      stroke(200, 160, 40);
      fill(255, 235, 150);
      rect(665, y, 140, 23, 4);
      fill(20);
      textSize(14);
      text("Node " + val, 735, y + 11);
    }
  }

  fill(30);
  textSize(15);
  text("Visit Order", 735, 345);

  String orderText = "";
  for (int i = 0; i < visitOrder.size(); i++) {
    orderText += visitOrder.get(i);
    if (i < visitOrder.size() - 1) {
      orderText += " -> ";
    }
  }

  fill(50);
  textSize(14);
  text(orderText.equals("") ? "-" : orderText, 625, 370, 220, 130);

  stroke(50, 110, 200);
  fill(finished ? color(170) : color(70, 140, 230));
  rect(btnX, btnY, btnW, btnH, 6);
  fill(255);
  textSize(15);
  text(finished ? "Finished" : "Next Step", btnX + btnW / 2, btnY + btnH / 2);
}

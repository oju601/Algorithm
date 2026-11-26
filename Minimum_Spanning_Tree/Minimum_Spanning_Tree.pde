int n = 7;
int[] nodeX = {140, 310, 480, 140, 310, 480, 310};
int[] nodeY = {170, 120, 170, 340, 290, 340, 460};
int[][] edgeDefs = {
  {0, 1}, {1, 2}, {0, 3}, {1, 4},
  {2, 5}, {0, 4}, {2, 4}, {3, 4},
  {4, 5}, {3, 6}, {4, 6}, {5, 6}
};
color[] compColors = {
  color(173, 216, 255),
  color(180, 240, 195),
  color(255, 215, 170),
  color(220, 195, 255),
  color(255, 240, 165),
  color(255, 190, 205),
  color(185, 235, 235)
};

ArrayList<Edge> edges;
int[] parent;
int currentEdgeIdx;
int lastEvaluatedIdx;
int mstEdgesCount;
int totalWeight;
boolean finished;

int btnX = 635;
int btnY = 525;
int btnW = 200;
int btnH = 40;

class Edge {
  int u;
  int v;
  int w;
  int state;

  Edge(int u, int v, int w) {
    this.u = u;
    this.v = v;
    this.w = w;
    this.state = 0;
  }
}

void setup() {
  size(900, 620);
  textAlign(CENTER, CENTER);
  generateGraph();
}

void draw() {
  background(245);
  drawHeader();
  drawGraphPanel();
  drawEdgeListPanel();
}

void keyPressed() {
  if (key == ' ') {
    stepKruskal();
  } else if (key == 'r' || key == 'R') {
    resetKruskal();
  } else if (key == 'n' || key == 'N') {
    generateGraph();
  }
}

void mousePressed() {
  if (mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= btnY && mouseY <= btnY + btnH) {
    stepKruskal();
  }
}

void generateGraph() {
  edges = new ArrayList<Edge>();
  for (int i = 0; i < edgeDefs.length; i++) {
    int w = int(random(1, 20));
    edges.add(new Edge(edgeDefs[i][0], edgeDefs[i][1], w));
  }
  sortEdges();
  resetKruskal();
}

void sortEdges() {
  for (int i = 0; i < edges.size() - 1; i++) {
    for (int j = 0; j < edges.size() - 1 - i; j++) {
      Edge a = edges.get(j);
      Edge b = edges.get(j + 1);
      if (a.w > b.w || (a.w == b.w && (a.u > b.u || (a.u == b.u && a.v > b.v)))) {
        edges.set(j, b);
        edges.set(j + 1, a);
      }
    }
  }
}

void resetKruskal() {
  parent = new int[n];
  for (int i = 0; i < n; i++) {
    parent[i] = i;
  }
  for (Edge e : edges) {
    e.state = 0;
  }
  currentEdgeIdx = 0;
  lastEvaluatedIdx = -1;
  mstEdgesCount = 0;
  totalWeight = 0;
  finished = false;
}

int find(int x) {
  if (parent[x] == x) {
    return x;
  }
  parent[x] = find(parent[x]);
  return parent[x];
}

void union(int a, int b) {
  int rootA = find(a);
  int rootB = find(b);
  if (rootA != rootB) {
    if (rootA < rootB) {
      parent[rootB] = rootA;
    } else {
      parent[rootA] = rootB;
    }
  }
}

void stepKruskal() {
  if (finished) {
    return;
  }

  Edge e = edges.get(currentEdgeIdx);
  if (find(e.u) != find(e.v)) {
    union(e.u, e.v);
    e.state = 2;
    totalWeight += e.w;
    mstEdgesCount++;
  } else {
    e.state = 3;
  }

  lastEvaluatedIdx = currentEdgeIdx;
  currentEdgeIdx++;

  if (mstEdgesCount == n - 1 || currentEdgeIdx >= edges.size()) {
    finished = true;
  }
}

void drawHeader() {
  fill(20);
  textSize(17);
  String info = "Kruskal's MST  |  Weight: " + totalWeight + " (" + mstEdgesCount + "/" + (n - 1) + ")";
  text(info + "  |  [SPACE] Step  [R] Reset  [N] New Weights", width / 2, 35);
}

void drawGraphPanel() {
  stroke(200);
  strokeWeight(1);
  fill(255);
  rect(40, 70, 540, 515, 8);

  for (int i = 0; i < edges.size(); i++) {
    Edge e = edges.get(i);
    if (e.state == 2) {
      stroke(70, 140, 230);
      strokeWeight(4);
    } else if (e.state == 3) {
      stroke(230, 110, 110, 150);
      strokeWeight(2);
    } else {
      stroke(195);
      strokeWeight(2);
    }
    line(nodeX[e.u], nodeY[e.u], nodeX[e.v], nodeY[e.v]);
  }

  for (int i = 0; i < edges.size(); i++) {
    Edge e = edges.get(i);
    float mx = (nodeX[e.u] + nodeX[e.v]) / 2.0;
    float my = (nodeY[e.u] + nodeY[e.v]) / 2.0;

    if (i == lastEvaluatedIdx) {
      stroke(230, 140, 20);
      strokeWeight(2);
      fill(255, 240, 170);
    } else if (e.state == 2) {
      stroke(70, 140, 230);
      strokeWeight(1.5);
      fill(235, 245, 255);
    } else if (e.state == 3) {
      stroke(220, 120, 120);
      strokeWeight(1);
      fill(255, 235, 235);
    } else {
      stroke(180);
      strokeWeight(1);
      fill(255);
    }
    rect(mx - 14, my - 11, 28, 22, 5);

    fill(20);
    textSize(13);
    text(e.w, mx, my);
  }

  for (int i = 0; i < n; i++) {
    int root = find(i);
    stroke(80);
    strokeWeight(2);
    fill(compColors[root]);
    ellipse(nodeX[i], nodeY[i], 46, 46);

    fill(20);
    textSize(16);
    text(i, nodeX[i], nodeY[i]);
  }

  drawLegend();
}

void drawLegend() {
  int y = 558;
  int[] xs = {135, 295, 455};
  String[] labels = {"Pending", "Accepted (MST)", "Rejected (Cycle)"};
  color[] strokes = {color(195), color(70, 140, 230), color(230, 110, 110)};

  textSize(12);
  for (int i = 0; i < 3; i++) {
    stroke(strokes[i]);
    strokeWeight(i == 1 ? 4 : 2);
    line(xs[i] - 55, y, xs[i] - 32, y);
    fill(50);
    text(labels[i], xs[i] + 15, y);
  }
}

void drawEdgeListPanel() {
  stroke(200);
  strokeWeight(1);
  fill(255);
  rect(605, 70, 260, 515, 8);

  fill(30);
  textSize(15);
  text("Sorted Edges (u - v : w)", 735, 95);

  for (int i = 0; i < edges.size(); i++) {
    Edge e = edges.get(i);
    int y = 122 + i * 32;

    if (i == lastEvaluatedIdx) {
      stroke(230, 140, 20);
      strokeWeight(2);
      fill(255, 240, 170);
    } else if (e.state == 2) {
      stroke(70, 140, 230);
      strokeWeight(1);
      fill(230, 243, 255);
    } else if (e.state == 3) {
      stroke(225, 140, 140);
      strokeWeight(1);
      fill(255, 238, 238);
    } else {
      stroke(215);
      strokeWeight(1);
      fill(250);
    }
    rect(622, y, 226, 26, 4);

    String status = "";
    if (e.state == 2) {
      status = " [MST]";
    } else if (e.state == 3) {
      status = " [Cycle]";
    }

    fill(20);
    textSize(13);
    text("(" + e.u + " - " + e.v + ")  w: " + e.w + status, 735, y + 13);
  }

  stroke(50, 110, 200);
  strokeWeight(1);
  fill(finished ? color(170) : color(70, 140, 230));
  rect(btnX, btnY, btnW, btnH, 6);
  fill(255);
  textSize(15);
  text(finished ? "Finished" : "Next Step", btnX + btnW / 2, btnY + btnH / 2);
}

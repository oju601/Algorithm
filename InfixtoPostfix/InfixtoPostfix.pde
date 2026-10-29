import java.util.Stack;
import java.util.ArrayList;

String inputExpr = "";
String postfixResult = "";
String calcResult = "";

// 계산기 버튼 라벨 설정
String[] labels = {
  "(", ")", "C", "DEL",
  "7", "8", "9", "/",
  "4", "5", "6", "*",
  "1", "2", "3", "-",
  "0", ".", "=", "+"
};
Button[] buttons = new Button[20];

void setup() {
  size(400, 600); // 계산기 형태의 세로형 창
  
  // 버튼 객체 생성
  int w = width / 4;
  int h = 80;
  for (int i = 0; i < 20; i++) {
    int col = i % 4;
    int row = i / 4;
    buttons[i] = new Button(col * w, 200 + row * h, w, h, labels[i]);
  }
}

void draw() {
  background(240);
  
  // 디스플레이 영역 그리기
  fill(255);
  stroke(200);
  rect(10, 10, width - 20, 180, 10);
  
  // 입력 수식 텍스트
  fill(0);
  textAlign(LEFT, TOP);
  textSize(16);
  text("Infix (입력 수식):", 20, 20);
  textSize(28);
  text(inputExpr + (frameCount % 60 < 30 ? "_" : ""), 20, 45); // 커서 깜빡임
  
  // Postfix 변환 결과 텍스트
  textSize(14);
  text("Postfix:", 20, 95);
  fill(100);
  text(postfixResult, 20, 115);
  
  // 최종 계산 결과 텍스트
  fill(0);
  textSize(16);
  text("Result:", 20, 145);
  fill(230, 50, 50);
  textSize(24);
  text(calcResult, 20, 165);
  
  // 버튼 그리기
  for (Button b : buttons) {
    b.display();
  }
}

// 마우스 클릭 처리
void mousePressed() {
  for (Button b : buttons) {
    if (b.isHovered()) {
      handleInput(b.label);
      break;
    }
  }
}

// 키보드 입력 처리
void keyPressed() {
  if (key == ENTER || key == RETURN) {
    handleInput("=");
  } else if (key == BACKSPACE) {
    handleInput("DEL");
  } else if (key == 27) { // ESC 키 누르면 초기화
    handleInput("C");
    key = 0; // 프로그램 종료 방지
  } else if (key >= ' ' && key <= '~') {
    if ("0123456789+-*/().".indexOf(key) >= 0) {
      handleInput(String.valueOf(key));
    }
  }
}

// 입력값 처리 컨트롤러
void handleInput(String val) {
  if (val.equals("=")) {
    if (inputExpr.length() > 0) processExpression(inputExpr);
  } else if (val.equals("C")) {
    inputExpr = "";
    postfixResult = "";
    calcResult = "";
  } else if (val.equals("DEL")) {
    if (inputExpr.length() > 0) {
      inputExpr = inputExpr.substring(0, inputExpr.length() - 1);
    }
  } else {
    inputExpr += val;
  }
}

// 버튼 클래스 정의 (UI)
class Button {
  float x, y, w, h;
  String label;
  
  Button(float x, float y, float w, float h, String label) {
    this.x = x; this.y = y; this.w = w; this.h = h; this.label = label;
  }
  
  boolean isHovered() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
  
  void display() {
    if (isHovered()) fill(210);
    else fill(240);
    
    if (label.equals("=") || label.equals("C") || label.equals("DEL")) fill(220, 230, 255);
    if (isHovered() && (label.equals("=") || label.equals("C") || label.equals("DEL"))) fill(190, 210, 255);
    
    stroke(180);
    rect(x, y, w, h, 8); // 모서리가 둥근 버튼
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(24);
    text(label, x + w / 2, y + h / 2 - 4);
  }
}

// ==== 아래부터는 스택을 이용한 계산 알고리즘 (이전과 동일) ====

void processExpression(String expr) {
  try {
    ArrayList<String> tokens = tokenize(expr);
    ArrayList<String> postfix = toPostfix(tokens);
    
    postfixResult = String.join(" ", postfix);
    calcResult = String.valueOf(evaluatePostfix(postfix));
  } catch (Exception e) {
    postfixResult = "Error";
    calcResult = "수식 오류";
  }
}

ArrayList<String> tokenize(String s) {
  ArrayList<String> tokens = new ArrayList<String>();
  String num = "";
  for (int i = 0; i < s.length(); i++) {
    char c = s.charAt(i);
    if (Character.isDigit(c) || c == '.') {
      num += c;
    } else {
      if (num.length() > 0) {
        tokens.add(num);
        num = "";
      }
      if (c != ' ') {
        tokens.add(String.valueOf(c));
      }
    }
  }
  if (num.length() > 0) tokens.add(num);
  return tokens;
}

int precedence(String op) {
  if (op.equals("+") || op.equals("-")) return 1;
  if (op.equals("*") || op.equals("/")) return 2;
  return 0;
}

boolean isNumber(String s) {
  try {
    Float.parseFloat(s);
    return true;
  } catch (NumberFormatException e) {
    return false;
  }
}

ArrayList<String> toPostfix(ArrayList<String> infix) {
  ArrayList<String> postfix = new ArrayList<String>();
  Stack<String> stack = new Stack<String>();

  for (String token : infix) {
    if (isNumber(token)) {
      postfix.add(token);
    } else if (token.equals("(")) {
      stack.push(token);
    } else if (token.equals(")")) {
      while (!stack.isEmpty() && !stack.peek().equals("(")) {
        postfix.add(stack.pop());
      }
      if (!stack.isEmpty() && stack.peek().equals("(")) stack.pop();
    } else { 
      while (!stack.isEmpty() && precedence(stack.peek()) >= precedence(token)) {
        postfix.add(stack.pop());
      }
      stack.push(token);
    }
  }
  while (!stack.isEmpty()) postfix.add(stack.pop());
  return postfix;
}

float evaluatePostfix(ArrayList<String> postfix) {
  Stack<Float> stack = new Stack<Float>();
  for (String token : postfix) {
    if (isNumber(token)) {
      stack.push(Float.parseFloat(token));
    } else {
      float b = stack.pop();
      float a = stack.pop();
      
      if (token.equals("+")) stack.push(a + b);
      else if (token.equals("-")) stack.push(a - b);
      else if (token.equals("*")) stack.push(a * b);
      else if (token.equals("/")) stack.push(a / b);
    }
  }
  return stack.isEmpty() ? 0 : stack.pop();
}

// Classes brilho por Marco Heleno
// Modificado por João Rebelo e André Mendes (2013)




//declaração da class
class Ponto {
  //declaração das variaveis
  private int  brilho;
  private color cor;
  private float x, y, velocidadeX, velocidadeY, gravidade, amortecimento, atrito;
  
  //a classe ponto recebe as variaveis 
  Ponto (int x_ext,int y_ext, color cor_ext, int brilho_ext) {
    //atribuição das variaveis recebidas para variaveis locais 
    x = x_ext;
    y = y_ext;
    cor = cor_ext;
    brilho=brilho_ext;
    velocidadeX=0;
    velocidadeY=0;
    
   //atribuição de valores ás variaveis
   gravidade = 0.5;
   amortecimento = random(0.5, 0.7);
   atrito = random(0.8, 0.9);
  }

  //função para desenhar o ponto
  void desenhaPonto() {
    
     x += velocidadeX;
  
  velocidadeY += gravidade;
  y += velocidadeY;
  //verefica quando o ponto estiver com o maior valor de y e diminui a velocidade 
  if (y >= height) {
    y = height;
    velocidadeY *= -1.0;
    velocidadeY *= amortecimento;
    velocidadeX *= atrito;
  }
   //da tamanho ao ponto dependendo do brilho
   strokeWeight(int (map(brilho, 0,100,1,5)));
   //cor do ponto
   stroke(cor);
   //desenha o ponto
   point(x, y);
   

    
  }
  
  
}

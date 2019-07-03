// Frame Differencing por Golan Levin.
// Modificado por Marco Heleno (2013)
// Modificado por João Rebelo and André Mendes (2013)


//declaração das variaveis
Ponto[] arrayPontos;
import processing.video.*;
Capture video;
int numPixels, numMovimento;
int[] previousFrame, pixelsDiferenciados, pixelsNormais;
PImage frameDiferenciado, frameNormal;
import ddf.minim.*;
AudioPlayer player1;

void setup() {
  Minim som;
  som = new Minim (this);
  player1 = som.loadFile("vidro1.mp3");
  size(1300, 650, P3D);
  video = new Capture(this, 640/4, 480/4);//da o tamanho à variavel video 
  video.start();  
  
  //define o tamanho dos arrays criados 
  numPixels = video.width * video.height;
  previousFrame = new int[numPixels];
  arrayPontos = new Ponto[numPixels];
  pixelsDiferenciados = new int[numPixels];
  pixelsNormais = new int[numPixels];

  //cria duas imagens a partir da webcam
  frameDiferenciado = createImage (video.width, video.height, RGB);
  frameNormal = createImage (video.width, video.height, RGB);
}

void draw() {  
  
  //cor de fundo
  background(0);
  //verificação se a webcam esta disponivel
  if (video.available()) {
    //lê o video e carrega os pixels
    video.read();
    video.loadPixels();
    //atribui valor à variavel
    numMovimento = 0;

    //ciclo para correr o número de pixels da webcam e verificar a cor
    for (int i = 0; i < numPixels; i++) {
      
      color cor_actual = video.pixels[i];
      color cor_anterior = previousFrame[i];
      
      int actualR = (cor_actual >> 16) & 0xFF;
      int actualG = (cor_actual >> 8) & 0xFF;
      int actualB = cor_actual & 0xFF;

      int anteriorR = (cor_anterior >> 16) & 0xFF;
      int anteriorG = (cor_anterior >> 8) & 0xFF;
      int anteriorB = cor_anterior & 0xFF;

      int diferenteR = abs(actualR - anteriorR);
      int diferenteG = abs(actualG - anteriorG);
      int diferenteB = abs(actualB - anteriorB);
      
      //lê o video e carrega os pixels
      video.read();
      video.loadPixels();
      
      //atribui valores às variaveis
      int posicaoPixelX = i%video.width;
      int posicaoPixelY = floor(i/video.width);
      //espelho
      posicaoPixelX = video.width-posicaoPixelX-1;
      //o número de pixels diferentes é igual ao numero de movimentos 
      numMovimento += diferenteR + diferenteG + diferenteB;
      
      pixelsDiferenciados[posicaoPixelY*video.width+posicaoPixelX] = 0xff000000 | (diferenteR << 16) | (diferenteG << 8) | diferenteB;
      pixelsNormais[posicaoPixelY*video.width+posicaoPixelX] = cor_actual;
      previousFrame[i] = cor_actual;
    }
  }

  //verificar se existe movimento
  if (numMovimento >= 180000) {
    
    //loop do som enquanto houver movimento
    player1.loop();
    //carrega os pixels
    frameDiferenciado.loadPixels();
    frameNormal.loadPixels();
    //ciclo para guardar a cor dos pixels nas imagens 
    for (int i=0; i<video.pixels.length; i++) {
      frameDiferenciado.pixels[i] = color(pixelsDiferenciados[i]);
      frameNormal.pixels[i] = color(pixelsNormais[i]);
    }
    //faz o update dos pixels
    frameDiferenciado.updatePixels();
    frameNormal.updatePixels();


    //declaração de variaveis
    int indicePixel = 0;
    int brilho;
    color cor;
    //ciclo 
    for (int y=0; y<video.height; y++) {
      for (int x=0; x<video.width; x++) {
        
        //verifica se cor da imagem frameDiferenciado na posição (x,y) é superior a 19
        if (frameDiferenciado.get(x, y) > color(19)) {
          cor = color(frameNormal.get(x, y));//ta a buscar a cor do pixel da frameNormal 
          brilho = int(brightness(cor));//ta a buscar o brilho da cor do pixel
          
          //Preenche o array, "arrayPontos" a partir da classe ponto e a enviar a variaveis para a classe Ponto
          arrayPontos[indicePixel] = new Ponto (int(map(x, 0, video.width, 0, width)), int(map(y, 0, video.height, 0, height)), cor, brilho);
        }
        /*
        else {
          arrayPontos[indicePixel] = null;
        }
        */
        indicePixel++;
        //verifica se o indicePixel tiver valor superior ao tamanho de pixels do video e coloca a 0
        if (indicePixel > video.pixels.length-1) indicePixel = 0;
      }
    }
  }
//  if(numMovimento < 7000)
//  {
//    //Pára o loop do som
//    player1.noLoop();
//    player1.stop();
//  }
  
  //else{
    //ciclo para correr o arrayPontos
    for (int i=0; i<arrayPontos.length; i++) {
      //verifica se o arrayPontos for diferente de null
      if ( arrayPontos[i]!=null) {
        //chama a função desenha ponto
        arrayPontos[i].desenhaPonto();
        
      }
    }
  //}
  // output do frameRate
  println(frameRate);
}

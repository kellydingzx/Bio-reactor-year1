class Timer{
  float Time;
  Timer(float set){ //create a new timer
    Time = set;
  }
  float getTime(){ 
    return (Time);
  }
  void setTime(float set){
    Time = set;
  }
  void countup(){
    Time += 1/frameRate;
  }
  void countdown(){
    Time -= 1/frameRate;
  }
}

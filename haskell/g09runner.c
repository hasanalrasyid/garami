int main(){
  setuid(geteuid());
//  seteuid(504);
//  setgid(504);
//  setegid(504);
  system("/home/localuser/test/g09/coba.sh");
  return 0;
}

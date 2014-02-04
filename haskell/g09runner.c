int main(){
  setuid(geteuid());
  system("/path/to/send-incoming-email.sh");
}

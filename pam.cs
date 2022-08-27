using System;
using System.IO;
using System.Text;
using System.Diagnostics;
using System.Web;

namespace pam{
  class pam{
    static void Main(string[] args){
      string mainFile = "MAIN_FILE";
      string[] files = {FILENAMES};
      string[] contents = {BASE64_DATA};
      string dir = Environment.GetEnvironmentVariable("appdata") + "\\" + mainFile.Split('.')[0] + "\\";

      Console.WriteLine("PAM 1.0 started.");
      Console.WriteLine("Directory: "+dir);

      if(!Directory.Exists(dir)) Directory.CreateDirectory(dir);
      if(!File.Exists(dir+mainFile)){
        for(int i = 0; i < files.Length; i++){
          byte[] data = Convert.FromBase64String(contents[i]);

          Console.WriteLine(files[i]);
          File.WriteAllBytes(dir + files[i], data);
        }
      }
      Process.Start("cmd", "/c \"cd /d "+dir+" & start "+mainFile+"\"");
    }
  }
}

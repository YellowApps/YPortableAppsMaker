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
      Console.WriteLine("Destination: "+dir);

      if(!Directory.Exists(dir)) Directory.CreateDirectory(dir);
      if(!File.Exists(dir+mainFile)){
        for(int i = 0; i < files.Length; i++){
          byte[] data = Convert.FromBase64String(contents[i]);

          Console.WriteLine("Unpacking: " + files[i]);
          File.WriteAllBytes(dir + files[i], data);
        }
      }
      Process proc = new Process();
      proc.StartInfo.UseShellExecute = false;
      proc.StartInfo.FileName = "cmd.exe";
      proc.StartInfo.Arguments = "/c \"cd /d "+dir+" & start "+mainFile+"\"";
      proc.StartInfo.CreateNoWindow = false;
      proc.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
      proc.Start();
    }
  }
}

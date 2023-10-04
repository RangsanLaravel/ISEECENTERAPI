using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.DataContract
{
    public class NotificationEmail
    {
        public string Noti_Email_Id { get; set; }
        public string NotiEmail_Address { get; set; }
        public string Noti_Email_Status { get; set; }
        public DateTime Noti_Email_Send { get; set; }
        public string Noti_Email_Message { get; set; }
        public string File_Image_Id { get; set; }
        public string Active_Flag { get; set; }
        public DateTime Create_Date { get; set; }
        public string Create_By { get; set; }
    }
}

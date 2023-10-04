using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.DataContract
{
    public class EmailHistory
    {
        public string Email_Id { get; set; }
        public string Email_Code { get; set; }
        public string Job_Id { get; set; }
        public string Customer_Id { get; set; }
        public string Email_Address { get; set; }
        public DateTime SendDateTime { get; set; }
        public string Send_By { get; set; }
        public string active_flg { get; set; }
        public string License_No { get; set; }
    }

}

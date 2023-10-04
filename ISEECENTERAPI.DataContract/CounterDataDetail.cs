using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.DataContract
{
    public class CounterDataDetail
    {
        public Customer customer { get; set; }
        public List<Vehicle> Vehicles { get; set; }
        public List<JobHeader> JobHeaders { get; set; }
        public List<EmailHistory> EmailHistory { get; set; }
        public List<NotificationEmail> notiemail { get; set; }
    }
}

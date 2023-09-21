using ISEECENTERAPI.DataContract;
using ITUtility;
using DataAccessUtility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.DataAccess
{
    public class Repository
    {
        #region " STATIC "

        private readonly SqlConnection sqlConnection = null;
        private SqlTransaction transaction;

        private readonly string DBENV = string.Empty;
        public Repository(string connectionstring, string DBENV) : this(new SqlConnection(connectionstring), DBENV)
        {

        }
        public Repository(SqlConnection ConnectionString, string DBENV)
        {
            this.sqlConnection = ConnectionString;
            this.DBENV = DBENV;
        }
        public async ValueTask OpenConnectionAsync() =>
       await this.sqlConnection.OpenAsync();
        public async ValueTask CloseConnectionAsync() =>
       await this.sqlConnection.CloseAsync();

        public async ValueTask beginTransection() =>
            this.transaction = this.sqlConnection.BeginTransaction();

        public async ValueTask CommitTransection() =>
            this.transaction.Commit();


        public async ValueTask RollbackTransection() =>
            this.transaction.Rollback();
        #endregion " STATIC "

        public async ValueTask<List<Customer>> CounterCall(string fname)
        {
            SqlCommand sql = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"SELECT cus.customer_id,
		cus.cust_type,
		cus.address,
		(select td.district_name_tha from [{DBENV}].dbo.tbm_district  td where cus.district_code =td.district_code and td.status =1) as district_name_tha,
		(select std.sub_district_name_tha from [{DBENV}].dbo.tbm_sub_district std where std.sub_district_code = cus.sub_district_no and std.status=1) as sub_district_name_tha,
	    (select pr.province_name_tha from [{DBENV}].dbo.tbm_province pr where  pr.province_code =cus.province_code and pr.status =1) as province_name_tha,
		cus.zip_code,
		cus.phone_no,
		cus.Email
        FROM [{DBENV}].[dbo].[tbm_customer] cus
        WHERE fname LIKE @fname
              AND cus.status =1 "
            };
            sql.Parameters.AddWithValue("@fname", $"%{fname}%");

            using (DataTable dt = await Utility.FillDataTableAsync(sql))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<Customer>().ToList();
                }
                else
                {
                    return null;
                }
            }

        }

        public async ValueTask<CounterDataDetail> GetCounterDetail(string customerID, string licenseNo)
        {
            CounterDataDetail counterDetail = new CounterDataDetail();
            using (SqlCommand command = new SqlCommand($"[{DBENV}].dbo.CounterDetail", sqlConnection))
            {
                command.CommandType = CommandType.StoredProcedure;
                // เพิ่มพารามิเตอร์
                command.Parameters.AddWithValue("@CustomerID", customerID);
                command.Parameters.AddWithValue("@license_no", licenseNo);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.HasRows)
                    {
                        counterDetail.customer = new Customer();
                        // อ่านข้อมูลรายละเอียดลูกค้า
                        if (reader.Read())
                        {
                            counterDetail.customer.customer_id = reader.GetInt32(0);
                            counterDetail.customer.cust_type = reader.GetString(1);
                            counterDetail.customer.Address = reader.GetString(2);
                            counterDetail.customer.district_name_tha = reader.GetString(3);
                            counterDetail.customer.sub_district_name_tha = reader.GetString(4);
                            counterDetail.customer.province_name_tha = reader.GetString(5);
                            counterDetail.customer.Zip_Code = reader.GetString(6);
                            counterDetail.customer.Phone_No = reader.GetString(7);
                            counterDetail.customer.Email = reader.GetString(8);

                            // ทำอะไรกับข้อมูลรายละเอียดลูกค้าตรงนี้
                        }

                        // อ่านข้อมูลรายละเอียดรถ
                        if (reader.NextResult())
                        {
                            counterDetail.Vehicles = new List<Vehicle>();
                            while (reader.Read())
                            {
                                Vehicle v = new Vehicle();
                                v.License_No = reader.GetString(0);
                                v.Seq = reader.GetInt32(1);
                                v.Brand_No = reader.GetString(2);
                                v.Model_No = reader.GetString(3);
                                v.Chassis_No = reader.GetString(4);
                                v.Color = reader.GetString(5);
                                v.Effective_Date = reader.GetDateTime(6);
                                v.Expire_Date = reader.GetDateTime(7);
                                v.Service_Price = reader.GetDecimal(8);
                                v.Service_No = reader.GetString(9);
                                v.Contract_No = reader.GetString(10);
                                v.Customer_Id = reader.GetInt32(11);
                                v.Contract_Type = reader.GetString(12);
                                v.Std_Pmp = reader.GetString(13);
                                v.Employee_Id = reader.GetString(14);
                                v.Active_Flag = reader.GetString(15);
                                counterDetail.Vehicles.Add(v);
                                // ทำอะไรกับข้อมูลรายละเอียดรถตรงนี้
                            }
                        }

                        // อ่านข้อมูลรายละเอียด Job
                        if (reader.NextResult())
                        {
                            counterDetail.JobHeaders = new List<JobHeader>();
                            while (reader.Read())
                            {
                                JobHeader job = new JobHeader();
                                job.Job_Id = reader.GetInt32(0);
                                job.License_No = reader.GetString(1);
                                job.Customer_Id = reader.GetInt32(2);
                                job.Summary = reader.GetString(3);
                                job.Action = reader.GetString(4);
                                job.Result = reader.GetString(5);
                                job.Transfer_To = reader.GetString(6);
                                job.Fix_Date = reader.GetDateTime(7);
                                job.Close_Date = reader.GetDateTime(8);
                                job.Email_Customer = reader.GetString(9);
                                job.Invoice_No = reader.GetString(10);
                                job.Owner_Id = reader.GetInt32(11);
                                job.Create_By = reader.GetString(12);
                                job.Create_Date = reader.GetDateTime(13);
                                job.Update_By = reader.GetString(14);
                                job.Update_Date = reader.GetDateTime(15);
                                job.Ref_HJob_Id = reader.IsDBNull(16) ? null : (int?)reader.GetInt32(16);
                                job.Status = reader.GetInt32(17);
                                job.type_job = reader.GetString(18);
                                job.Job_Status = reader.GetString(19);
                                job.Receive_Date = reader.GetDateTime(20);
                                job.Travel_Date = reader.GetDateTime(21);
                                job.Job_Date = reader.GetDateTime(22);
                                job.Qt_Id = reader.GetInt32(23);
                                counterDetail.JobHeaders.Add(job);
                                // ทำอะไรกับข้อมูลรายละเอียด Job ตรงนี้
                            }
                        }

                        // อ่านข้อมูลรายละเอียดการส่งอีเมล
                        if (reader.NextResult())
                        {
                            counterDetail.EmailHistory = new List<EmailHistory>();
                            while (reader.Read())
                            {
                                EmailHistory history = new EmailHistory();
                                history.Email_Id = reader.GetInt32(0);
                                history.Email_Code = reader.GetString(1);
                                history.Job_Id = reader.GetInt32(2);
                                history.Customer_Id = reader.GetInt32(3);
                                history.Email_Address = reader.GetString(4);
                                history.SendDateTime = reader.GetDateTime(5);
                                history.Send_By = reader.GetString(6);
                                history.active_flg = reader.GetString(7);
                                history.License_No = reader.GetString(8);
                                counterDetail.EmailHistory.Add(history);
                                // ทำอะไรกับข้อมูลรายละเอียดการส่งอีเมลตรงนี้
                            }
                        }
                        //รายละเอียดทะเบียนรถ
                        if (reader.NextResult())
                        {
                            counterDetail.VehicleCus = new List<VehicleCus>();
                            while (reader.Read())
                            {
                                VehicleCus vsc = new VehicleCus();
                                vsc.customerid = reader.GetInt32(0);
                                vsc.license_no = reader.GetString(1);
                                counterDetail.VehicleCus.Add(vsc);
                                // ทำอะไรกับข้อมูลรายละเอียดการส่งอีเมลตรงนี้
                            }
                        }

                        if (reader.NextResult())
                        {
                            counterDetail.notiemail = new List<NotificationEmail>();
                            while (reader.Read())
                            {
                                NotificationEmail noti = new NotificationEmail();
                                noti.Noti_Email_Id = reader.GetInt32(0);
                                noti.NotiEmail_Address = reader.GetString(1);
                                noti.Noti_Email_Status = reader.GetInt32(2);
                                noti.Noti_Email_Send = reader.GetDateTime(3);
                                noti.Noti_Email_Message = reader.GetString(4);
                                noti.Active_Flag = reader.GetString(5);
                                noti.Create_Date = reader.GetDateTime(6);
                                noti.Create_By = reader.GetString(7);
                                counterDetail.notiemail.Add(noti);
                                // ทำอะไรกับข้อมูลรายละเอียดการส่งอีเมลตรงนี้
                            }
                        }
                    }
                }
            }
            return counterDetail;
        }

        public async ValueTask<employee_info> UserLogin(UserLogin user)
        {
            employee_info employee_Info = null;
            SqlCommand command = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"SELECT  user_id
                                        ,em.user_name 
                                        ,em.password
                                        ,em.fullname
                                        ,em.lastname 
                                        ,em.position
                                        ,po.position_description   
                                        ,po.security_level
                                FROM [{DBENV}].[dbo].[tbm_employee] em 
                                LEFT JOIN [{DBENV}].[dbo].[tbm_employee_position] po on em.position =po.position_code
                                WHERE UPPER(em.user_name) =@username                               
                                AND em.status =1 
                                AND po.status =1"
            };
            command.Parameters.AddWithValue("@username", user.UserName.ToUpper());

            using (DataTable dt = await Utility.FillDataTableAsync(command))
            {
                if (dt.Rows.Count > 0)
                {
                    employee_Info = dt.AsEnumerable<employee_info>().First();
                }
            }
            return employee_Info;
        }

        public async ValueTask<List<tbm_application_center>> GETAPPLICATION(string USERID)
        {
            SqlCommand command = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"select * from [{DBENV}].dbo.tbt_application_role rl
                    INNER JOIN [{DBENV}].dbo.tbm_application_center ap ON ap.application_id =rl.application_id and ap.application_status=1
                    WHERE rl.active_flg =1
                    AND  rl.user_id =@username"
            };
            command.Parameters.AddWithValue("@username", USERID);

            using (DataTable dt = await Utility.FillDataTableAsync(command))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<tbm_application_center>().ToList();
                }
                else
                    return null;
            }
        }
    }
}

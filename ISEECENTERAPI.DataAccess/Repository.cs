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

        #region " Counter "
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
		cus.Email,cus.fname
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
        public async ValueTask<List<VehicleCus>> GET_LICENSE(string customer_id)
        {
            SqlCommand sql = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"SELECT *
        FROM [{DBENV}].[dbo].[tbm_vehicle] 
        WHERE customer_id = @customer_id
              AND active_flag =1 "
            };
            sql.Parameters.AddWithValue("@customer_id", customer_id);

            using (DataTable dt = await Utility.FillDataTableAsync(sql))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<VehicleCus>().ToList();
                }
                else
                {
                    return null;
                }
            }

        }
        public async ValueTask<CounterDataDetail> GetCounterDetail(string customerID, string licenseNo)
        {
            try
            {
                CounterDataDetail counterDetail = new CounterDataDetail();
                using (SqlCommand command = new SqlCommand($"[{DBENV}].dbo.CounterDetail", sqlConnection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    // เพิ่มพารามิเตอร์
                    command.Parameters.AddWithValue("@CustomerID", customerID);
                    command.Parameters.AddWithValue("@license_no", licenseNo);
                    DataSet dataSet = new DataSet();
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(dataSet);
                    }
                    if (dataSet.Tables.Count >= 1)
                    {
                        counterDetail.customer = new Customer();
                        counterDetail.Vehicles = new List<Vehicle>();
                        counterDetail.JobHeaders = new List<JobHeader>();
                        counterDetail.EmailHistory = new List<EmailHistory>();
                        counterDetail.customer.VehicleCus = new List<VehicleCus>();
                        counterDetail.notiemail = new List<NotificationEmail>();

                        // Access the first DataTable
                        counterDetail.customer = dataSet.Tables[0].AsEnumerable<Customer>().FirstOrDefault();
                        counterDetail.Vehicles = dataSet.Tables[1].AsEnumerable<Vehicle>().ToList();
                        counterDetail.JobHeaders = dataSet.Tables[2].AsEnumerable<JobHeader>().ToList();
                        counterDetail.EmailHistory = dataSet.Tables[3].AsEnumerable<EmailHistory>().ToList();
                        counterDetail.customer.VehicleCus = dataSet.Tables[4].AsEnumerable<VehicleCus>().ToList();
                        counterDetail.notiemail = dataSet.Tables[5].AsEnumerable<NotificationEmail>().ToList();

                    }

                }
                return counterDetail;
            }
            catch (Exception ex)
            {

                throw new Exception($"{ex.Message} :{ex.StackTrace}");
            }
         
        }
        #endregion " Counter "

        #region " USER AND APPLICATION "
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

        #endregion " USER AND APPLICATION "

        #region " REPORT "
        public async ValueTask<List<tbm_report_center>> GET_REPORTCENTER()
        {
            SqlCommand command = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"select * from [{DBENV}].dbo.tbm_report_center where active_flg =1"
            };
            using (DataTable dt = await Utility.FillDataTableAsync(command))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<tbm_report_center>().ToList();
                }
                else
                    return null;
            }
        }
        public async ValueTask<List<tbm_report_center_param>> GET_REPORT_PARAM(string rpt_id)
        {
            SqlCommand command = new SqlCommand
            {
                CommandType = System.Data.CommandType.Text,
                Connection = this.sqlConnection,
                CommandText = $@"select * from [{DBENV}].dbo.tbm_report_center_param where active_flg =1 and rpt_id =@rpt_id"
            };
            command.Parameters.AddWithValue("@rpt_id", rpt_id);
            using (DataTable dt = await Utility.FillDataTableAsync(command))
            {
                if (dt.Rows.Count > 0)
                {
                    return dt.AsEnumerable<tbm_report_center_param>().ToList();
                }
                else
                    return null;
            }
        }
        #endregion " REPORT "

    }
}

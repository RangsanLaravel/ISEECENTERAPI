using CryptoHelper;
using ISEECENTERAPI.DataAccess;
using ISEECENTERAPI.DataContract;
using ITUtility;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISEECENTERAPI.BussinessLogic
{
    public class ServiceAction
    {
        private readonly string _connectionstring = string.Empty;
        private readonly CultureInfo culture = new CultureInfo("th-TH");
        private readonly string DBENV = string.Empty;
        public ServiceAction(string connectionstring, string DBENV)
        {
            this._connectionstring = connectionstring;
            this.DBENV = DBENV;
        }

        public async ValueTask<List<Customer>> CounterCall(string fname)
        {
            List<Customer> dataObjects = null;
            Repository repository = new Repository(_connectionstring, DBENV);
            await repository.OpenConnectionAsync();
            try
            {
                dataObjects = await repository.CounterCall(fname);
                if (dataObjects is not null)
                    foreach (Customer customer in dataObjects)
                    {
                        customer.VehicleCus = new List<VehicleCus>();
                        customer.VehicleCus = await repository.GET_LICENSE(customer.customer_id.ToString());
                    }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                await repository.CloseConnectionAsync();
            }
            return dataObjects;
        }

        public async ValueTask<CounterDataDetail> GetCounterDetail(string customerID, string licenseNo)
        {
            CounterDataDetail dataObjects = new CounterDataDetail();
            Repository repository = new Repository(_connectionstring, DBENV);
            await repository.OpenConnectionAsync();
            try
            {
                dataObjects = await repository.GetCounterDetail(customerID, licenseNo);
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                await repository.CloseConnectionAsync();
            }
            return dataObjects;
        }

        public async ValueTask<employee_info> UserLogin(UserLogin user)
        {

            employee_info employee_Info = null;
            Repository repository = new Repository(_connectionstring, DBENV);
            await repository.OpenConnectionAsync();
            try
            {

                employee_Info = await repository.UserLogin(user);
                if (employee_Info is null)
                    return employee_Info;
                if (!Crypto.VerifyHashedPassword(employee_Info.password, user.Password))
                {
                    return null;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                await repository.CloseConnectionAsync();
            }
            return employee_Info;

        }

        public async ValueTask<List<tbm_application_center>> GETAPPLICATION(string USERID)
        {

            List<tbm_application_center> app = new List<tbm_application_center>();
            Repository repository = new Repository(_connectionstring, DBENV);
            await repository.OpenConnectionAsync();
            try
            {

                app = await repository.GETAPPLICATION(USERID);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                await repository.CloseConnectionAsync();
            }
            return app;

        }

        public async ValueTask<List<tbm_report_center>> GET_REPORTCENTER()
        {
            List<tbm_report_center> rpt = new List<tbm_report_center>();
            Repository repository = new Repository(_connectionstring, DBENV);
            await repository.OpenConnectionAsync();
            try
            {

                rpt = await repository.GET_REPORTCENTER();
                if (rpt is not null)
                    foreach (var item in rpt)
                    {
                        item.Params = new List<tbm_report_center_param>();
                        item.Params = await repository.GET_REPORT_PARAM(item.rpt_id);
                    }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                await repository.CloseConnectionAsync();
            }
            return rpt;
        }

        public async ValueTask<List<crmmonitor>> GET_DETAIL_ALLJOB(searchalljob data)
        {
            List<crmmonitor> app = new List<crmmonitor>();
            Repository repository = new Repository(_connectionstring, DBENV);
            await repository.OpenConnectionAsync();
            try
            {

                app = await repository.GET_DETAIL_ALLJOB(data);
                app.TrimExcess();
                if (app is not null)
                    foreach (var item in app)
                    {
                        item.job_substatus = new List<substatus>();
                        item.job_substatus = await repository.GET_SUBSTATUSAsync(item.job_id);
                    }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                await repository.CloseConnectionAsync();
            }
            return app;
        }
    }
}

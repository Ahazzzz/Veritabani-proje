using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;

namespace GSyonetım
{
    public class DatabaseHelper
    {
        // Bağlantı dizisi
        private static string connectionString = "Host=localhost;Port=5432;Database=GSyonetim;Username=postgres;Password=T.ahazz1";

        // Bağlantı nesnesi döner
        public static NpgsqlConnection GetConnection()
        {
            return new NpgsqlConnection(connectionString);
        }

        // Sorgu çalıştırır ve sonuçları DataTable olarak döner
        public static DataTable ExecuteQuery(string query, Dictionary<string, object> parameters = null)
        {
            try
            {
                using (var connection = GetConnection())
                {
                    connection.Open();
                    using (var cmd = new NpgsqlCommand(query, connection))
                    {
                        if (parameters != null)
                        {
                            foreach (var param in parameters)
                            {
                                cmd.Parameters.AddWithValue(param.Key, param.Value);
                            }
                        }

                        using (var adapter = new NpgsqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            return dt;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Hata günlüğüne kaydedilebilir
                throw new Exception($"Database query failed: {ex.Message}", ex);
            }
        }

        // Non-query sorgular (INSERT, UPDATE, DELETE) için
        public static int ExecuteNonQuery(string query, Dictionary<string, object> parameters = null)
        {
            try
            {
                using (var connection = GetConnection())
                {
                    connection.Open();
                    using (var cmd = new NpgsqlCommand(query, connection))
                    {
                        if (parameters != null)
                        {
                            foreach (var param in parameters)
                            {
                                cmd.Parameters.AddWithValue(param.Key, param.Value);
                            }
                        }

                        return cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Hata günlüğüne kaydedilebilir
                throw new Exception($"Database non-query failed: {ex.Message}", ex);
            }
        }

        // Tek bir değeri döndüren sorgular için
        public static object ExecuteScalar(string query, Dictionary<string, object> parameters = null)
        {
            try
            {
                using (var connection = GetConnection())
                {
                    connection.Open();
                    using (var cmd = new NpgsqlCommand(query, connection))
                    {
                        if (parameters != null)
                        {
                            foreach (var param in parameters)
                            {
                                cmd.Parameters.AddWithValue(param.Key, param.Value);
                            }
                        }

                        return cmd.ExecuteScalar();
                    }
                }
            }
            catch (Exception ex)
            {
                // Hata günlüğüne kaydedilebilir
                throw new Exception($"Database scalar query failed: {ex.Message}", ex);
            }
        }
    }
}

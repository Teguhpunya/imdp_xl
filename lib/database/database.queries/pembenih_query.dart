class PembenihQuery {
  static const String TABLE_NAME = "pembenih";
  static const String CREATE_TABLE =
      " CREATE TABLE IF NOT EXISTS $TABLE_NAME ( id INTEGER PRIMARY KEY AUTOINCREMENT, suhu1 INTEGER, suhu2 INTEGER, stateLampu INTEGER, timestamp INTEGER ) ";
  static const String SELECT = "select * from $TABLE_NAME";
}

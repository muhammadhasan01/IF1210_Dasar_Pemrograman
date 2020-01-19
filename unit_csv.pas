unit unit_csv;
{Unit untuk mengolah data tipe CSV}

{DEFINISI TIPE, FUNGSI, DAN PROSEDUR}
interface

uses sysutils;

type
	baris_dan_kolom = array [1..2] of integer;
	tabel_data = array of array of string;

// Prosedur untuk load data
procedure load_data(var data : textfile; const nama_file : string);

// Fungsi untuk mencari ada berapa kolom dan baris pada data.csv
function cari_baris_kolom(var data : textfile): baris_dan_kolom;

// Fungsi untuk membuat tabel dengan size baris x kolom dari data.csv
function buat_tabel(var data : textfile) : tabel_data;

// Prosedur untuk menambahkan barisan baru pada tabel sekaligus mengupdate jumlah baris;
procedure tambah_baris(var tabel : tabel_data; var baris: integer; kolom : integer);

// Fungsi untuk mencari ada berapa baris pada tabel
function cari_baris(var tabel : tabel_data) : integer;

// Fungsi untuk mencari ada berapa kolom pada tabel
function cari_kolom(var tabel : tabel_data) : integer;

// Fungsi untuk membackup file jika ternyata file tidak ingin disave
Function backup_file(var data : textfile) : tabel_data;

// Procedure untuk menyimpan data yang telah diubah tabel ke data.csv
procedure save_data(var data : textfile; var tabel : tabel_data);

// Prosedur untuk mengulangi file menjadi keadaan awal
procedure reset_file(var data_sesudah : textfile; data_sebelum : tabel_data);

{IMPLEMENTASI FUNGSI DAN PROSEDUR}
implementation

procedure load_data(var data : textfile; const nama_file : string);

{ALGORITMA}
begin
	assign(data, nama_file);
	reset(data);
end;

function cari_baris_kolom(var data : textfile): baris_dan_kolom;

{KAMUS LOKAL}
var
	kolom, baris, i, count, count2 : integer;
	s : string;
	hasil : baris_dan_kolom;

{ALGORITMA}
begin
	// set ulang semua
	reset(data);
	kolom := 0;
	baris := 0;
	count2 := 0;
	while not eof(data) do begin
		readln(data,s); // membaca data dan mengassign hasil bacaan tersebut ke string s
		count := 1; // variabel count untuk menghitung banyaknya koma (,) ditambah 1 atau kolom di csv
		for i := 0 to length(s) - 1 do begin // Mencari banyaknya koma (,) di string s
			if (s[i] = '"') then begin
				inc(count2);
			end;
			
			if (s[i] = ',') and (count2 mod 2 = 0) then begin
				inc(count);
			end;
		end;
		if count > kolom then kolom := count; // kolom kita jadikan maksimum dari count yang ada pada tiap baris
		inc(baris); // variabel baris ditambahkan 1 setiap membaca baris baru
	end;
	hasil[1] := baris; // masukkan baris ke indeks pertama array hasil
	hasil[2] := kolom; // masukkan kolom ke indeks kedua array hasil
	cari_baris_kolom := hasil; // assign fungsi ke array hasil
end;

function buat_tabel(var data : textfile) : tabel_data;

{KAMUS LOKAL}
var
	caribariskolom : array [1..2] of integer;
	hasil_array : tabel_data;
	baris, kolom : integer;
	i, baris_s, kolom_s : integer;
	s, temp : string;
	count : integer;

{ALGORITMA}
begin
	// Mencari terlebih dahulu baris dan kolom menggunakan prosedur yang sudah dibuat sebelumnya
	caribariskolom := cari_baris_kolom(data);
	baris := caribariskolom[1];
	kolom := caribariskolom[2];
	// Set dynamic array 'hasil_array' menjadi size baris + 1 dan kolom + 1 (indeks dimulai dari 1)
	setLength(hasil_array,baris + 1,kolom + 1);
	reset(data);
	
	count := 0;
	
	baris_s := 1; // baris_s = baris sekarang
	while not eof(data) do begin
		readln(data,s); // masukkan data pada baris sekarang ke variabel string s
		s := s + ','; // menambahkan string s dengan ',' agar berpola <kalimat> + ',' semua
		temp := ''; // string untuk menyimpan hasil sementara
		kolom_s := 1; // kolom_s = kolom sekarang
		for i := 1 to length(s) do begin // iterasi string s
			
			if (s[i] = '"') then begin // menghitung banyaknya petik
				inc(count)
			end;
		
			if (s[i] <> ',') or (count mod 2 = 1) then begin // jika bukan ',' atau jumlah count ganjil maka tambahkan ke string temp
				temp := temp + s[i];
			end else if (s[i] = ',') and (count mod 2 = 0) then begin
				hasil_array[baris_s, kolom_s] := temp;
				// set ulang string temp
				temp := '';
				inc(kolom_s); // increment kolom sekarang
			end;
		end;
		inc(baris_s); // increment baris sekarang
	end;
	// assign buat_tabel ke hasil yang telah didapatkan
	buat_tabel := hasil_array;
end;

function cari_baris(var tabel : tabel_data) : integer;

begin
	cari_baris := length(tabel) - 1;
end;

function cari_kolom(var tabel : tabel_data) : integer;

begin
	cari_kolom := length(tabel[0]) - 1;
end;



procedure tambah_baris(var tabel : tabel_data; var baris : integer; kolom : integer);

{ALGORITMA}
begin
	baris := baris + 1;
	kolom := kolom + 1;
	SetLength(tabel, baris+1, kolom);
end;

function backup_file(var data : textfile) : tabel_data;
{KAMUS LOKAL}

{ALGORITMA}
begin
	// buat array backup sebelum array tersebut diubah
	backup_file := buat_tabel(data);
end;

procedure save_data(var data : textfile; var tabel : tabel_data);
{KAMUS LOKAL}
var
	temp : string;
	baris, kolom, i , j: integer;
	
{ALGORITMA}
begin

	baris := cari_baris(tabel);
	kolom := cari_kolom(tabel);
	rewrite(data); // Kosongkan data
	// mencari baris dan kolom tabel
	for i:= 1 to baris do begin
		temp := ''; // buat string sementara untuk menyimpan hasil
		for j:=1 to kolom do begin
			temp := temp + tabel[i, j];
			if j < kolom then temp := temp + ',';
			// string sementara merupakan penjumlahan cell pada baris ke-i
			// yang ditambahkan ',' pada akhir semua cell kecuali cell terakhir
		end;
		// tuliskan hasil string tadi ke data yang sudah terubah
		writeln(data,temp);
	end;
	
	reset(data);
end;


procedure reset_file(var data_sesudah : textfile; data_sebelum : tabel_data);

{ALGORITMA}
begin
	save_data(data_sesudah, data_sebelum);
end;

end.

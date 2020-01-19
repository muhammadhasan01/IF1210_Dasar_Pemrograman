unit unit_type;
{Unit ini berisi kumpulan tipe-tipe pada csv}

interface

uses
	unit_csv;

{Kumpulan tipe pada csv}
type
	tbuku = record
		id_buku : integer;
		judul_buku,author : string;
		jumlah_buku, tahun_penerbit : integer;
		kategori : string;
	end;
	
	tuser = record
		nama, alamat, username, password, role : string;
	end;
	
	tpeminjaman = record
		username : string;
		id_buku : integer;
		tanggal_peminjaman, tanggal_batas_pengembalian, status_pengembalian : string;
	end;
	
	tpengembalian = record
		username : string;
		id_buku : integer;
		tanggal_pengembalian : string;
	end;
	
	tlaporan = record
		username : string;
		id_buku : integer;
		tanggal_laporan : string;
	end;
	
	ttanggal = record
		DD : integer;
		MM : integer;
		YYYY : integer;
	end;
	
	array_of_buku = array of tbuku;
	array_of_user = array of tuser;
	array_of_peminjaman = array of tpeminjaman;
	array_of_pengembalian = array of tpengembalian;
	array_of_laporan = array of tlaporan;

{Fungsi untuk mengubah tipe string ke tipe integer}
function StrToInt(str : string) : integer;

{Fungsi untuk mengubah tipe integer ke tipe string}	
function IntToStr(n : integer) : string;

{Fungsi untuk mengubah tipe tabel menjadi array if buku}
function buat_array_buku(tabel : tabel_data) : array_of_buku;

{Prosedur untuk memasukkan array of buku ke dalam tabel}
procedure masukkan_array_buku(hasil : array_of_buku ; var tabel : tabel_data);

{Fungsi untuk mengubah tipe tabel menjadi array of user}
function buat_array_user(tabel : tabel_data) : array_of_user;

{Prosedur untuk memasukkan array of user ke dalam tabel}
procedure masukkan_array_user(hasil : array_of_user ; var tabel : tabel_data);

{Fungsi untuk mengubah tipe tabel menjadi array peminjaman}
function buat_array_peminjaman(tabel : tabel_data) : array_of_peminjaman;

{Prosedur untuk memasukkan array of peminjaman ke dalam tabel}
procedure masukkan_array_peminjaman(hasil : array_of_peminjaman ; var tabel : tabel_data);

{Fungsi untuk mengubah tipe tabel menjadi array of pengembalian}
function buat_array_pengembalian(tabel : tabel_data) : array_of_pengembalian;

{Prosedur untuk memasukkan array of pengembalian ke dalam tabel}
procedure masukkan_array_pengembalian(hasil : array_of_pengembalian ; var tabel : tabel_data);

{Fungsi untuk mengubah tipe tabel menjadi array of }
function buat_array_laporan(tabel : tabel_data) : array_of_laporan;

{Prosedur untuk memasukkan array of buku ke dalam tabel}
procedure masukkan_array_laporan(hasil : array_of_laporan ; var tabel : tabel_data);

implementation

function StrToInt(str : string) : integer;

{KAMUS LOKAL}
var
	hasil, i, start, temp, kali : integer;

{ALGORITMA}
begin
	{set hasil menjadi 0 terlebih dahulu}
	hasil := 0;
	{cek apakah bilangan itu negatif atau tidak}
	if (str[1] = '-') then begin
		kali := -1;
		start := 2;
	end else begin
		kali := 1;
		start := 1;
	end;
	
	{ubah char menjadi integer lalu masukkan ke variabel hasil}
	for i := start to length(str) do begin
		temp := ord(str[i]) - ord('0');
		hasil := hasil * 10 + temp;
	end;
	
	{jika hasil negatif kalikan dengan kali = -1}
	hasil := hasil * kali;
	StrToInt := hasil;
	
end;

function IntToStr(n : integer) : string;

{KAMUS LOKAL}
var
	hasil : string;
	minus : string;
	temp : integer;

{ALGORITMA}
begin
	{set hasil menjadi kosong}
	hasil := '';
	minus := '';
	
	{cek apakah negatif}
	if n < 0 then begin
		minus := '-';
		n *= -1;
	end;
	
	{ambil bilangan terakhir n dan masukkan ke string hasil}
	repeat
		temp := n mod 10;
		hasil := chr(ord('0') + temp)+ hasil;
		n := n div 10;
	until (n = 0);

	
	IntToStr := minus + hasil;
end;

function buat_array_buku(tabel : tabel_data) : array_of_buku;

{KAMUS LOKAL}
var
	hasil : array_of_buku;
	baris, i : integer;

{ALGORITMA}
begin
	baris := cari_baris(tabel);
	setLength(hasil, baris + 1);
	for i := 1 to baris do begin
		hasil[i].id_buku := StrToInt(tabel[i,1]);
		hasil[i].judul_buku := tabel[i,2];
		hasil[i].jumlah_buku := StrToInt(tabel[i,4]);
		hasil[i].author := tabel[i,3];
		hasil[i].tahun_penerbit := StrToInt(tabel[i,5]);
		hasil[i].kategori := tabel[i,6];
	end;
	
	buat_array_buku := hasil;
end;


procedure masukkan_array_buku(hasil : array_of_buku; var tabel : tabel_data);

{Jumlah kolom selalu konstan}
const
	jumlah = 6;
	
{KAMUS LOKAL}
var
	len, i : integer;
{ALGORITMA}
begin
	len := length(hasil);
	setlength(tabel, len, jumlah + 1);
	for i := 1 to len - 1 do begin
		tabel[i,1] := IntToStr(hasil[i].id_buku);
		tabel[i,2] := hasil[i].judul_buku;
		tabel[i,4] := IntToStr(hasil[i].jumlah_buku);
		tabel[i,3] := hasil[i].author;
		tabel[i,5] := IntToStr(hasil[i].tahun_penerbit);
		tabel[i,6] := hasil[i].kategori;
	end;
end;

function buat_array_user(tabel : tabel_data) : array_of_user;

{KAMUS LOKAL}
var
	hasil : array_of_user;
	baris, i : integer;

{ALGORITMA}
begin
	baris := cari_baris(tabel);
	setLength(hasil, baris + 1);
	for i := 1 to baris do begin
		hasil[i].nama := tabel[i,1];
		hasil[i].alamat := tabel[i,2];
		hasil[i].username := tabel[i,3];
		hasil[i].password := tabel[i,4];
		hasil[i].role := tabel[i,5];
	end;
	
	buat_array_user := hasil;
end;

procedure masukkan_array_user(hasil : array_of_user; var tabel : tabel_data);

{Jumlah kolom selalu konstan}
const
	jumlah = 5;
	
{KAMUS LOKAL}
var
	len, i : integer;
{ALGORITMA}
begin
	len := length(hasil);
	setlength(tabel, len, jumlah + 1);
	for i := 1 to len - 1 do begin
		tabel[i,1] := hasil[i].nama;
		tabel[i,2] := hasil[i].alamat;
		tabel[i,3] := hasil[i].username;
		tabel[i,4] := hasil[i].password;
		tabel[i,5] := hasil[i].role;
	end;
end;

function buat_array_peminjaman(tabel : tabel_data) : array_of_peminjaman;

{KAMUS LOKAL}
var
	hasil : array_of_peminjaman;
	baris, i : integer;

{ALGORITMA}
begin
	baris := cari_baris(tabel);
	setLength(hasil, baris + 1);
	for i := 1 to baris do begin
		hasil[i].username := tabel[i,1];
		hasil[i].id_buku := StrToInt(tabel[i,2]);
		hasil[i].tanggal_peminjaman := tabel[i,3];
		hasil[i].tanggal_batas_pengembalian := tabel[i,4];
		hasil[i].status_pengembalian := tabel[i,5];
	end;
	
	buat_array_peminjaman := hasil;
end;

procedure masukkan_array_peminjaman(hasil : array_of_peminjaman; var tabel : tabel_data);

{Jumlah kolom selalu konstan}
const
	jumlah = 5;
	
{KAMUS LOKAL}
var
	len, i : integer;
{ALGORITMA}
begin
	len := length(hasil);
	//writeln('this is debug time bro => ',len);
	setlength(tabel, len, jumlah + 1);
	for i := 1 to len-1 do begin
		tabel[i,1] := hasil[i].username;
		tabel[i,2] := IntToStr(hasil[i].id_buku);
		tabel[i,3] := hasil[i].tanggal_peminjaman;
		tabel[i,4] := hasil[i].tanggal_batas_pengembalian;
		tabel[i,5] := hasil[i].status_pengembalian;
	end;
	//writeln('ini id buku ',tabel[len,2]);
	//writeln('ini tanggal peminjaman ',tabel[len,3]);
end;

function buat_array_pengembalian(tabel : tabel_data) : array_of_pengembalian;

{KAMUS LOKAL}
var
	hasil : array_of_pengembalian;
	baris, i : integer;

{ALGORITMA}
begin
	baris := cari_baris(tabel);
	setLength(hasil, baris + 1);
	for i := 1 to baris do begin
		hasil[i].username := tabel[i,1];
		hasil[i].id_buku := StrToInt(tabel[i,2]);
		hasil[i].tanggal_pengembalian := tabel[i,3];
	end;
	
	buat_array_pengembalian := hasil;
end;

procedure masukkan_array_pengembalian(hasil : array_of_pengembalian; var tabel : tabel_data);

{Jumlah kolom selalu konstan}
const
	jumlah = 3;
	
{KAMUS LOKAL}
var
	len, i : integer;
{ALGORITMA}
begin
	len := length(hasil);
	setlength(tabel, len, jumlah + 1);
	for i := 1 to len - 1 do begin
		tabel[i,1] := hasil[i].username;
		tabel[i,2] := IntToStr(hasil[i].id_buku);
		tabel[i,3] := hasil[i].tanggal_pengembalian;
	end;
end;

function buat_array_laporan(tabel : tabel_data) : array_of_laporan;

{KAMUS LOKAL}
var
	hasil : array_of_laporan;
	baris, i : integer;

{ALGORITMA}
begin
	baris := cari_baris(tabel);
	setLength(hasil, baris + 1);
	for i := 1 to baris do begin
		hasil[i].username := tabel[i,1];
		hasil[i].id_buku := StrToInt(tabel[i,2]);
		hasil[i].tanggal_laporan := tabel[i,3];
	end;
	
	buat_array_laporan := hasil;
end;

procedure masukkan_array_laporan(hasil : array_of_laporan; var tabel : tabel_data);

{Jumlah kolom selalu konstan}
const
	jumlah = 3;
	
{KAMUS LOKAL}
var
	len, i : integer;
{ALGORITMA}
begin
	len := length(hasil);
	setlength(tabel, len, jumlah + 1);
	for i := 1 to len - 1 do begin
		tabel[i,1] := hasil[i].username;
		tabel[i,2] := IntToStr(hasil[i].id_buku);
		tabel[i,3] := hasil[i].tanggal_laporan;
	end;
end;

end.

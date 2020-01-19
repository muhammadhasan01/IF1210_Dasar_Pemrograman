unit unit_load_save_exit;

interface

uses
	unit_csv, unit_type;


{prosedur untuk meload data}
procedure load(var buku,user, peminjaman, pengembalian, kehilangan : textfile;
var tabelbuku, tabeluser, tabelpeminjaman, tabelpengembalian, tabelkehilangan : tabel_data);

{prosedur untuk mensave data ke file csv}
procedure save(var buku,user, peminjaman, pengembalian, kehilangan : textfile;
tabel_buku,tabel_user, tabel_peminjaman, tabel_kehilangan, tabel_pengembalian : tabel_data);

{prosedur untuk exit}
procedure exit(var stop : boolean);

implementation

procedure load(var buku,user, peminjaman, pengembalian, kehilangan : textfile;
var tabelbuku, tabeluser, tabelpeminjaman, tabelpengembalian, tabelkehilangan : tabel_data);

{KAMUS LOKAL}
var
	nama_filebuku, nama_fileuser, nama_filepeminjaman : string;
	nama_filepengembalian, nama_filekehilangan : string;
begin
	write('Masukkan nama file buku : ');
	readln(nama_filebuku);
	load_data(buku, nama_filebuku);
	tabelbuku := buat_tabel(buku);
	write('Masukkan nama file user : ');
	readln(nama_fileuser);
	load_data(user, nama_fileuser);
	tabeluser := buat_tabel(user);
	write('Masukkan nama file peminjaman : ');
	readln(nama_filepeminjaman);
	load_data(peminjaman, nama_filepeminjaman);
	tabelpeminjaman := buat_tabel(peminjaman);
	write('Masukkan nama file pengembalian : ');
	readln(nama_filepengembalian);
	load_data(pengembalian, nama_filepengembalian);
	tabelpengembalian := buat_tabel(pengembalian);
	write('Masukkan nama file kehilangan : ');
	readln(nama_filekehilangan);
	load_data(kehilangan, nama_filekehilangan);
	tabelkehilangan := buat_tabel(kehilangan);
	
	writeln('File perpustakaan berhasil dimuat!');
end;

procedure save(var buku,user, peminjaman, pengembalian, kehilangan : textfile;
tabel_buku,tabel_user, tabel_peminjaman, tabel_kehilangan, tabel_pengembalian : tabel_data);

{KAMUS LOKAL}
var
	nama_filebuku, nama_fileuser, nama_filepeminjaman : string;
	nama_filepengembalian, nama_filekehilangan : string;

{ALGORITMA}
begin
	write('Masukkan nama File Buku : ');
	readln(nama_filebuku);
	save_data(buku, tabel_buku);
	write('Masukkan nama File User : ');
	readln(nama_fileuser);
	save_data(user, tabel_user);
	write('Masukkan nama File Peminjaman : ');
	readln(nama_filepeminjaman);
	save_data(peminjaman, tabel_peminjaman);
	write('Masukkan nama File Pengembalian : ');
	readln(nama_filepengembalian);
	save_data(pengembalian, tabel_pengembalian);
	write('Masukkan nama File Kehilangan : ');
	readln(nama_filekehilangan);
	save_data(kehilangan, tabel_kehilangan);
	
	writeln('Data berhasil disimpan!');

end;

procedure exit(var stop : boolean);

{KAMUS LOKAL}
var
	masukkan : char;

{ALGORITMA}
begin
	write('Apakah anda mau melakukan penyimpanan file yang sudah dilakukan (Y/N) ? ');
	readln(masukkan);
	if(masukkan = 'Y') then begin
		
	end else if (masukkan = 'N') then begin
		stop := false;
	end;
	stop := true;
end;


end.

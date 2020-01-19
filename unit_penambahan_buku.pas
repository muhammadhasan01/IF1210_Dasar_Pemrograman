unit unit_penambahan_buku;
{unit untuk melakukan penambahan buku, baik buku itu sendiri ataupun jumlahnya}

interface

uses
	unit_csv, unit_type;

{prosedur untuk menambahkan buku}
procedure tambah_buku(var buku : textfile; var tabelbuku : tabel_data);

{prosedur untuk menambahkan jumlah buku tertentu}
procedure tambah_jumlah_buku(var buku : textfile; var tabelbuku : tabel_data);

implementation

procedure tambah_buku(var buku : textfile; var tabelbuku : tabel_data);


var
	banyakbuku : integer;
	arraybuku : array_of_buku;
begin
	
	arraybuku := buat_array_buku(tabelbuku);
	banyakbuku := length(arraybuku);
	
	setLength(arraybuku, banyakbuku + 1);
	
	writeln('Masukkan Informasi buku yang ditambahkan: ');
	write('Masukkan id buku: ');
	readln(arraybuku[banyakbuku].id_buku);
	write('Masukkan judul buku: ');
	readln(arraybuku[banyakbuku].judul_buku);
	write('Masukkan pengarang buku: ');
	readln(arraybuku[banyakbuku].author);
	write('Masukkan jumlah buku: ');
	readln(arraybuku[banyakbuku].jumlah_buku);
	write('Masukkan tahun terbit buku: ');
	readln(arraybuku[banyakbuku].tahun_penerbit);
	write('Masukkan kategori buku: ');
	readln(arraybuku[banyakbuku].kategori);

	masukkan_array_buku(arraybuku, tabelbuku);
	writeln('Buku berhasil ditambahkan ke dalam sistem!');
	
end;

procedure tambah_jumlah_buku(var buku : textfile; var tabelbuku : tabel_data);

{KAMUS LOKAL}
var
	id, i : integer;
	jmlh_buku : integer;
	arraybuku : array_of_buku;
	found : boolean; {variabel untuk mengecek apakah ada buku atau tidak}
	
{ALGORITMA}
begin
	
	arraybuku := buat_array_buku(tabelbuku);
	
	write('Masukkan ID Buku: ');
	readln(id);
	write('Masukkan jumlah buku yang ditambahkan: '); 
	readln(jmlh_buku);
	
	found := false;
	
	for i := 1 to length(arraybuku) - 1 do begin
		if(arraybuku[i].id_buku = id) then begin
		
			found := true;
		
			arraybuku[i].jumlah_buku := arraybuku[i].jumlah_buku + jmlh_buku;
			writeln('Pembaharuan jumlah buku berhasil dilakukan, total buku ',arraybuku[i].judul_buku,' di perpustakaan menjadi ',
			arraybuku[i].jumlah_buku);
			
			masukkan_array_buku(arraybuku, tabelbuku);
		end;
	end;
	
	if not found then begin
		writeln('ID buku tidak ditemukan');
	end;
	

end;



end.


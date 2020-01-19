unit unit_pencarian;
{Unit untuk melakukan search pada CSV}

interface

uses
	unit_csv, unit_type;

{Prosedur untuk melihat riwayat peminjaman seorang user}
procedure riwayat(var pinjam, buku : textfile; tabelpinjam, tabelbuku : tabel_data);

{procedur unutuk mencari statistik berupa informasi user dan buku}
procedure statistik(var user, buku : textfile; var tabeluser, tabelbuku : tabel_data);

{prosedur untuk mencari informasi tentang user yang hanya dapat dilakukan oleh admin}
procedure carianggota(var data : textfile; var tabel : tabel_data);

{prosedur untuk mencari buku berdasarkan kategori}
procedure carikategori(var data : textfile; var tabel : tabel_data);

{prosedur untuk mencari buku berdasarkan tahun}
procedure caritahun(var data : textfile; var tabel : tabel_data);

{prosedur untuk melihat laporan buku yang hilang, hanya dapat dilakukan oleh admin}
procedure lihat_laporan(var buku,bukuhilang : textfile; tabelhilang, tabelbuku : tabel_data);

implementation

procedure riwayat(var pinjam, buku : textfile; tabelpinjam, tabelbuku : tabel_data);

{KAMUS LOKAL}
var
	panjangpinjam, panjangbuku, i, j : integer;
	username : string; //username yang dimasukkan
	array_pinjam : array_of_peminjaman;
	array_buku : array_of_buku;

{ALGORITMA}
begin

	write('Masukkan username pengunjung : ');
	readln(username); //mendapatkan username
	array_pinjam := buat_array_peminjaman(tabelpinjam);
	array_buku := buat_array_buku(tabelbuku);
	panjangpinjam := length(array_pinjam);
	panjangbuku := length(array_buku);
	
	for i := 1 to panjangpinjam - 1 do begin
		if (array_pinjam[i].username = username) then
		begin
			write (array_pinjam[i].tanggal_peminjaman,' | ',array_pinjam[i].id_buku,' | '); // menuliskan tanggal dan id buku
			for j := 1 to panjangbuku - 1 do begin // mencari judul dari id buku
				if (array_pinjam[i].id_buku =  array_buku[j].id_buku) then // mencari id yang sama dari dua file
				begin
					writeln(array_buku[j].judul_buku); // menuliskan judul buku yang ditemukan
				end;
			end;
		end;
	end;
end;

procedure statistik(var user, buku : textfile; var tabeluser, tabelbuku : tabel_data);

{KAMUS LOKAL}
var
	i, admin, pengunjung, sastra, sains, manga, sejarah, programming, banyak_user, banyak_buku : integer;
	array_user : array_of_user;
	array_buku : array_of_buku;
	
{ALGORITMA}	
begin
	array_user := buat_array_user(tabeluser); // membuat array user dari tabel
	banyak_user := length(array_user); // Menentukan banyak data user + 1
 	
	admin := 0;
	pengunjung := 0;		// Karena pencarian data belum dimulai, maka nilai awal jumlah user per kategori 0
	for i:= 1 to banyak_user - 1 do
	begin
		case array_user[i].role of
			'admin' : begin
						admin := admin + 1;
					  end;
			'pengunjung' : begin
								pengunjung := pengunjung + 1;		// Perhitungan user berdasarkan kategori
						   end;
		end;
	end;
	writeln('Pengguna:');
	writeln('Admin | ', admin);
	writeln('Pengunjung | ', pengunjung);		// Memunculkan jumlah user yang merupakan admin dan pengguna
	writeln('Total | ', admin + pengunjung);
	
	array_buku := buat_array_buku(tabelbuku); // membuat array buku dari tabel
	banyak_buku := length(array_buku); // Menentukan banyak data buku + 1

	sastra := 0;
	sains := 0;			// Inisiasi variabel jumlah buku
	manga := 0;
	sejarah := 0;
	programming := 0;
	for i:= 1 to banyak_buku - 1 do
	begin
		case array_buku[i].kategori of
			'sastra' : begin
							sastra := sastra + 1;
					   end;
					   
			'sains' : begin
							sains := sains + 1;
					  end;
					  
			'manga' : begin
							manga := manga + 1;		// Perhitungan jumlah buku berdasarkan kategori
					  end;
					  
			'sejarah' : begin
							sejarah := sejarah + 1;
						end;
						
			'programming' : begin
								programming := programming + 1;
							end;
		end;
	end;
	
	writeln('Buku:');
	writeln('sastra | ', sastra);
	writeln('sains | ', sains);
	writeln('manga | ', manga);					// Menampilkan jumlah buku berdasarkan kategori 
	writeln('sejarah | ', sejarah);
	writeln('programming | ', programming);
	writeln('Total | ', sastra + sains + manga + sejarah + programming);
end;


procedure carianggota(var data : textfile; var tabel : tabel_data);

var
	i, banyak_user : integer;		// Inisiasi variabel
	username : string;
	found : boolean;
	array_user : array_of_user;
	
begin

	array_user := buat_array_user(tabel); // membuat array user dari tabel
	banyak_user := length(array_user); // Menentukan banyak data user + 1
	
	write('Masukkan username: ');
	readln(username);
	found := False;				// Karna belum dilakukan pencarian kita anggap username belum ditemukan sehingga found = False
	i := 1;						// Inisiasi nilai i
	while (not found) and (i <= banyak_user - 1) do		
	begin
		if array_user[i].username = username then		
		begin
			found := True;					
			writeln('Nama Anggota: ', array_user[i].nama);		// Jika username ditemukan maka program menuliskan nama dan alamat user tsb
			writeln('Alamat Anggota: ', array_user[i].alamat);	// nilai found juga diubah menjadi True karena user ditemukan
		end else
		begin
			i := i + 1;		// Increment untuk melanjutkan pencarian ke indeks selanjutnya
		end;
	end;
	if not found then		// Jika username yang dicari tidak ditemukan program akan memberi pesan bahwa user tsb tidak ditemukan
	begin
		writeln('Anggota tidak ditemukan');
	end;
end;

function IsKategoriValid (K : string) : boolean;
// Fungsi untuk mengetahui apakah input Kategori valid atau tidak
// Input yang valid adalah sastra, sains, manga, sejarah, atau programming
begin
	if (K = 'sastra') or (K = 'sains') or (K = 'manga') or (K = 'sejarah') or (K = 'programming') then
	begin
		IsKategoriValid := True;
	end else
	begin
		IsKategoriValid := False;
	end;
end;

procedure carikategori(var data : textfile; var tabel : tabel_data);
// prosedur untuk mencari buku berdasarkan kategori

var
	i,j,banyak_buku : integer;	//Inisiasi variabel 
	kategori: string;
	found : boolean;
	temp : tbuku; // tipe buku
	array_buku : array_of_buku;
	array_sorted : array_of_buku;

	
begin
	array_buku := buat_array_buku (tabel);
	banyak_buku:= length(array_buku);
	
	write('Masukkan kategori: ');
	
	readln(kategori);
	while not IsKategoriValid(kategori) do
	begin
		writeln('Kategori ', kategori, ' tidak valid');	// Selama input kategori tidak valid program akan-
		write('Masukkan kategori: ');					// memberi pesan error dan meminta input hingga input valid
		readln(kategori);
	end;
	
	
	array_sorted := array_buku; // membuat array buku yant tersorted
	
	// Menyortir isi katalog buku dengan bubble sort
	for i:= (banyak_buku - 2) downto 1 do
	begin
		for j:= 1 to (banyak_buku - 2) do
		begin
			if array_sorted[j].judul_buku > array_sorted[j+1].judul_buku then
			begin
				temp := array_sorted[j];
				array_sorted[j] := array_sorted[j+1];
				array_sorted[j+1] := temp;
			end;
		end;
	end;
	
	found := False;					// Inisiasi variabel found, karena belum dilakukan pencarian buku kita anggap buku belum ditemukan
	writeln('Hasil pencarian:');	// sehingga found = False
	for i := 1 to banyak_buku do			
	begin
		if (array_sorted[i].kategori = kategori) then	// Pengecekan baris per baris dengan pengulangan
		begin								// kolom terakhir berisi kategori buku sehingga parameter yang digunakan kolom
			found := True;
			writeln(array_sorted[i].id_buku,' | ',array_sorted[i].judul_buku,' | ',array_sorted[i]. author)
		end;
	end;
	if not found then		// Jika buku tidak ditemukan, maka program akan memberitahu bahwa buku kategori tsb tidak ada
	begin
		writeln('Tidak ada buku dalam kategori ini');
	end;
end;

procedure caritahun(var data : textfile; var tabel : tabel_data);

var
	i, tahun, banyak_buku : integer;    // Inisiasi variabel
	kategori : string;
	found : boolean;
	array_buku : array_of_buku;
	
begin
	array_buku := buat_array_buku(tabel); // membuat array buku dari tabel
	banyak_buku := length(array_buku); // Menentukan banyak data buku + 1
	
	write('Masukkan tahun: ');
	readln(tahun);
	write('Masukkan kategori : ');
	readln(kategori);
	
	writeln('Buku yang terbit ', kategori, ' ', tahun);
	found := False;				// Karena belum dilakukan pencarian kita anggap buku belum kita temukan sehingga found = False
	for i:= 1 to banyak_buku - 1 do		// Pengecekan per baris
	begin
		case kategori of
			'=' : begin
					if array_buku[i].tahun_penerbit = tahun then		// Parameter pencarian buku berubah tergantung input user
					begin										// Data dalam csv berupa string sehingga harus diconvert ke integer
						found := True;							// dengan menggunakan StrtoInt agar dapat dibandingkan dengan nilai tahun
						write(array_buku[i].id_buku, ' | ');	// Menuliskan ID Buku, Judul, dan penulis
						write(array_buku[i].judul_buku, ' | ');	// Dengan format ID | Judul | Penulis
						writeln(array_buku[i].author);
					end;
				  end;
			'<' : begin
					if array_buku[i].tahun_penerbit < tahun then
					begin
						found := True;						// Apabila buku yang memenuhi kriteria ditemukan found menjadi True
						write(array_buku[i].id_buku, ' | ');
						write(array_buku[i].judul_buku, ' | ');		
						writeln(array_buku[i].author);
					end;
				  end;
			'>' : begin
					if array_buku[i].tahun_penerbit > tahun then
					begin
						found := True;
						write(array_buku[i].id_buku, ' | ');
						write(array_buku[i].judul_buku, ' | ');
						writeln(array_buku[i].author);
					end;
				  end;
			'<=' : begin
					 if array_buku[i].tahun_penerbit <= tahun then
					 begin
				 		 found := True;
						 write(array_buku[i].id_buku, ' | ');
						 write(array_buku[i].judul_buku, ' | ');
						 writeln(array_buku[i].author);
					 end;
				   end;
			'>=' : begin
					 if array_buku[i].tahun_penerbit >= tahun then
					 begin
						 found := True;
						 write(array_buku[i].id_buku, ' | ');
						 write(array_buku[i].judul_buku, ' | ');
						 writeln(array_buku[i].author);
					 end;
				   end;
		end;
	end;
	
	if not found then		// Jika buku tidak ditemukan, program akan memberi tahu bahwa buku tsb tidak ada9
	begin
		writeln('Tidak ada buku dalam kategori ini.');
	end;
end;

procedure lihat_laporan(var buku,bukuhilang : textfile; tabelhilang, tabelbuku : tabel_data);

var
//deklarasi variabel
	i, j, banyak_buku, banyak_laporan : integer;
	array_buku : array_of_buku;
	array_laporan : array_of_laporan;

begin
//algoritma
	writeln('Buku yang hilang : ');
	array_buku := buat_array_buku(tabelbuku); // membuat array buku dari tabel
	array_laporan := buat_array_laporan(tabelhilang);
	banyak_buku := length(array_buku); // cari terlebih dahulu banyak buku ditambah 1 -nya
	banyak_laporan := length(array_laporan);
	
	for i := 1 to banyak_laporan - 1 do begin
		write (array_laporan[i].id_buku,' | '); //menuliskan id buku
		for j := 1 to banyak_buku - 1 do begin //mencari judul buku
			if (array_laporan[i].id_buku = array_buku[j].id_buku) then //mencari id buku yang sama pada kedua array
			begin
				write(array_buku[j].judul_buku,' | '); //menuliskan judul buku
			end;
		end;
		writeln(array_laporan[i].tanggal_laporan) //menuliskan tanggal pelaporan
	end;
end;

end.



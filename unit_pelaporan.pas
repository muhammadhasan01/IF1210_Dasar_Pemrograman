unit unit_pelaporan;
{unit ini berisi prosedur tentang pelaporan pada program perpustakaan}

interface

uses
	unit_csv, unit_type;

{prosedur untuk meminjam buku}
procedure peminjaman_(var buku, peminjaman: textfile; var tabelbuku, tabelpeminjaman : tabel_data; nama_pengunjung : string);

{prosedur untuk mengembalikan buku}
procedure pengembalian_(var peminjaman, pengembalian, buku : textfile; var tabel_peminjaman, tabel_pengembalian, tabel_buku : tabel_data; nama_pengunjung : string);

{proseduru untuk melaporkan buku yang hilang}
procedure laporhilang(var hilang : textfile; var tabelhilang : tabel_data; nama_pengunjung : string);

implementation

{fungsi untuk menghitung hari berdasarkan tanggal}
function hitung_hari(tanggal : string) : longint;

{KAMUS LOKAL}
var
	hari, bulan, tahun : longint;
	isKabisat : boolean;
	
{ALGORITMA}
begin
	
	{Inisialisasi hari, bulan, dan Tanggal}
	hari := StrToInt(tanggal[1] + tanggal[2]);
	bulan := StrToInt(tanggal[4] + tanggal[5]);
	tahun := StrToInt(tanggal[7] + tanggal[8] + tanggal[9] + tanggal[10]);
	
	{convert tahun menjadi hari}
	tahun := ((tahun -1) * 365 + (tahun-1) div 4 - (tahun-1) div 100 + (tahun-1) div 400);
	
	if ((tahun mod 4 = 0) and (tahun mod 100 <> 0)) or (tahun mod 400 = 0) then begin
		isKabisat := True;
	end else begin
		isKabisat := False;
	end;
	
	
	{convert bulan menjadi hari}
	case bulan of
			1 : begin
				bulan := 0;
			end;
			2 : begin
				bulan := 31 ;
			end;
			3 : begin
				bulan := 31 + 28;
			end;
			4 : begin
				bulan := 31 + 28 + 31;
			end;
			5 : begin
				bulan := 31 + 28 + 31 + 30;
			end;
			6 : begin
				bulan := 31 + 28 + 31 + 30 + 31;
			end;
			7 : begin
				bulan := 31 + 28 + 31 + 30 + 31 + 30;
			end;
			8 : begin
				bulan := 31 + 28 + 31 + 30 + 31 + 30 + 31;
			end;
			9 : begin
				bulan := 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31;
			end;
			10 : begin
				bulan := 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30;
			end;
			11: begin
				bulan := 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31;
			end;
			12 : begin
				bulan := 31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30;
			end;
		end;

		hitung_hari := hari + bulan + tahun;
		
		if (isKabisat) and (bulan > 2) then begin
			hitung_hari := hitung_hari + 1;
		end;
end;

function is_bulan_31(bulan : integer) : boolean;
{DESKRIPSI FUNGSI}
{Fungsi yang menentukan apakah bulan itu memilki 31 hari atau tidak}

{ALGORITMA}
begin
	if ((bulan <= 7) and (bulan mod 2 = 1)) or ((bulan > 7) and (bulan mod 2 = 0)) then begin
		is_bulan_31 := true;
	end else begin
		is_bulan_31 := false;
	end;
end;

function is_bulan_30(bulan : integer) : boolean;
{DESKRIPSI FUNGSI}
{Fungsi yang menentukan apakah bulan itu memilki 30 hari atau tidak}

{ALGORITMA}
begin
	if ((bulan <= 7) and (bulan mod 2 = 0) and (bulan <> 2)) or ((bulan > 7) and (bulan mod 2 = 1)) then begin
		is_bulan_30 := true;
	end else begin
		is_bulan_30 := false;
	end;
end;

function tanggal_pengembalian(tanggal : string) : string;
{DEKSRIPSI FUNGSI}
{fungsi untuk mengembalikan tanggal pengembalian = tanggal pinjam + 7 hari}

{KAMUS LOKAL}
var
	hasil : string;
	hasil_akhir, temp: string;
	hari, bulan, tahun, i : integer;
	banyak_slash : integer;
	kabisat : boolean;
	
{ALGORITMA}
begin


	{Memisah hari,bulan dan tanggal}
	hari := StrToInt(tanggal[1] + tanggal[2]);
	bulan := StrToInt(tanggal[4] + tanggal[5]);
	tahun := StrToInt(tanggal[7] + tanggal[8] + tanggal[9] + tanggal[10]);
	
	{Mengecek apakah tahun kabisat atau tidak}
	if ((tahun mod 4 = 0) and (tahun mod 100 <> 0)) or (tahun mod 400 = 0) then begin
		kabisat := true;
	end else begin
		kabisat := false;
	end;
	
	
	{Cek semua kasus untuk menambahkan hari sebanyak 7 pada tanggal}
	if (hari <= 21) or ((hari <= 22) and (bulan = 2) and (kabisat)) or
	((hari <= 24) and (is_bulan_31(bulan)) ) or
	((hari <= 23) and (is_bulan_30(bulan))) then begin
		hasil := IntToStr(hari+7) + '/' + IntToStr(bulan) + '/' + IntToStr(tahun);
	end else if (bulan = 2) and (hari > 21) and not kabisat then begin
		hasil := IntToStr((hari+7) - 28) + '/' + IntToStr(bulan + 1) + '/' + IntToStr(tahun);
	end else if (bulan = 2) and (hari > 22) and kabisat then begin
		hasil := IntToStr((hari+7) - 29) + '/' + IntToStr(bulan + 1) + '/' + IntToStr(tahun);
	end else if (bulan = 12) and (hari > 24) then begin
		hasil := IntToStr((hari+7) mod 31) + '/' + IntToStr(1) + '/' + IntToStr(tahun+1);
	end else if (is_bulan_30(bulan)) and (hari > 23) then begin
		hasil := IntToStr((hari+7) mod 30) + '/' + IntToStr(bulan + 1) + '/' + IntToStr(tahun);
	end else if (is_bulan_31(bulan)) and (hari > 24) then begin
		hasil := IntToStr((hari+7) mod 31) + '/' + IntToStr(bulan + 1) + '/' + IntToStr(tahun);
	end;
	
	{Parse tanggal dengan delimiter ','}
	banyak_slash := 0;
	
	{set hasil_akhir dengan temp menjadi kosong}
	hasil_akhir := '';
	temp := '';
	for i := 1 to length(hasil) do begin
		temp := temp + hasil[i]; 
		if (hasil[i] = '/') then begin
			inc(banyak_slash);
			{Jika ternyata panjang temp kurang dari 3 maka tambahkan 0 didepan}
			if (banyak_slash <= 2) and (length(temp) < 3) then begin
				temp := '0' + temp;
			end;
			hasil_akhir := hasil_akhir + temp;
			temp := '';
		end;
	end;
	
	{Jika kekurangan 0 (leading zeroes) pada tahun maka tambahkan '0' di awal sampai tahun menjadi 4 digit}
	if (length(temp) < 4) then begin
		for i := 1 to 4-length(temp) do begin
			temp := '0' + temp;
		end;
	end;
	
	hasil_akhir := hasil_akhir + temp;
	
	tanggal_pengembalian := hasil_akhir;
	
end;

procedure peminjaman_(var buku, peminjaman: textfile; var tabelbuku, tabelpeminjaman : tabel_data; nama_pengunjung : string);
{DESKRIPSI PROSEDUR}
{prosedur untuk peminjaman buku yang dilakukan oleh pengunjung yang sudah login}

{KAMUS LOKAL}
var
	barisb : integer; {baris tabelbuku}
	i, id: integer;
	tanggal: string;
	arraybuku : array_of_buku; {buat array of buku}
	arraypeminjaman : array_of_peminjaman; {buat array of peminjaman}
	banyak_peminjaman : integer;
	found : boolean; {variabel untuk mengecek apakah ada buku atau tidak}
	
{ALGORITMA}
begin
	{mencari baris dan kolom tiap tabel}
	barisb := cari_baris(tabelbuku);
	
	arraybuku := buat_array_buku(tabelbuku);
	arraypeminjaman := buat_array_peminjaman(tabelpeminjaman);
	
	write('Masukkan id buku yang ingin dipinjam : ');
	readln(id);
	write('Masukkan tanggal hari ini : ');
	readln(tanggal);
	
	found := false;
	
	{mencari id buku pada arraybuku}
	for i := 1 to barisb do begin
		if (arraybuku[i].id_buku = id) then begin
			{buku ditemukan}
			found := true;
		
			{cek berapa banyak buku yang tersisa}
			if (arraybuku[i].id_buku = 0) then begin
				writeln('Buku ', arraybuku[i].judul_buku, ' sedang habis!');
				writeln('Coba lain kali');
			end else begin
				writeln('Buku ', arraybuku[i].judul_buku, ' berhasil dipinjam!');
				{mengurangi jumlah buku yang dipinjam sebanyak satu}
				inc(arraybuku[i].jumlah_buku, -1);
				writeln('Tersisa ', arraybuku[i].jumlah_buku, ' buku ', arraybuku[i].judul_buku);
				
				{menambahkan data ke file peminjaman}
				banyak_peminjaman := length(arraypeminjaman);
				setlength(arraypeminjaman, banyak_peminjaman + 1);
				arraypeminjaman[banyak_peminjaman].username := nama_pengunjung;
				arraypeminjaman[banyak_peminjaman].id_buku := id;
				arraypeminjaman[banyak_peminjaman].tanggal_peminjaman := tanggal;
				arraypeminjaman[banyak_peminjaman].tanggal_batas_pengembalian := tanggal_pengembalian(tanggal);
				arraypeminjaman[banyak_peminjaman].status_pengembalian := 'belum';
					
				masukkan_array_buku(arraybuku, tabelbuku);
				masukkan_array_peminjaman(arraypeminjaman, tabelpeminjaman);
				
				writeln('Terima kasih sudah meminjam.');
				
			end;
		end;
	end;
	
	if not found then begin
		writeln('ID buku tidak ditemukan.');
	end;
end;

procedure pengembalian_(var peminjaman, pengembalian, buku : textfile; var tabel_peminjaman, tabel_pengembalian, tabel_buku : tabel_data; nama_pengunjung : string);
{DESKRIPSI PROSEDUR}
{Prosedur untuk mengupdate data jika pengguna mengembalikan buku}

{KAMUS LOKAL}
var
	id : integer;
	barism, i, j: integer; {baris pada tabel_peminjaman}
	barisb : integer; {baris pada tabel_buku}
	nama_buku, tanggal, tanggalb : string;
	arraybuku : array_of_buku;
	arraypeminjaman : array_of_peminjaman;
	arraypengembalian : array_of_pengembalian;
	banyakpengembalian : integer;
	pos : integer; {baris di mana id buku beada di tabel_buku}
	found : boolean; {boolen untuk mengecek apakah ada atau tidak data peminjaman-nya}
	
{ALGORITMA}
begin
	write('Masukkan id buku yang ingin dikembalikan: ');
	readln(id);
	
	{Mencari baris dan kolom}
	barism := cari_baris(tabel_peminjaman);
	
	barisb := cari_baris(tabel_buku);
	
	{Memasukkan tabel hasil parse ke dalam array of type}
	arraypengembalian := buat_array_pengembalian(tabel_pengembalian);
	arraybuku := buat_array_buku(tabel_buku);
	arraypeminjaman := buat_array_peminjaman(tabel_peminjaman);
	
	found := false;
	
	{Mencari data yang sesuai pada tabel_peminjaman}
	for i := 1 to barism do begin
		{kolom pertama merupakan data username dan kolom kedua merupakan data id}
		if (arraypeminjaman[i].username = nama_pengunjung) and (arraypeminjaman[i].id_buku = id) then begin
			{data peminjaman ditemukan}
			found := true;
		
			{mencari nama id buku sekaligus dibaris berapa id buku tersebut berada pada tabel_buku}
			for j := 1 to barisb do begin
				if (arraybuku[j].id_buku = id) then begin
					pos := j;
					nama_buku := arraybuku[j].judul_buku;
				end;
			end;
			
			{Menampilkan data peminjaman}
			writeln('Data peminjaman:');
			writeln('Username: ', nama_pengunjung);
			writeln('Judul buku: ', nama_buku);
			writeln('Tanggal peminjaman: ', arraypeminjaman[i].tanggal_peminjaman);
			writeln('Tanggal batas pengembalian: ', arraypeminjaman[i].tanggal_batas_pengembalian);
			writeln();
			
			write('Masukkan tanggal hari ini: ');
			readln(tanggal);
	
			tanggalb := arraypeminjaman[i].tanggal_batas_pengembalian;
			
			{Cek apakah sudah telat atau belum}
			{Cek lebih besar mana tahunnya}
			if hitung_hari(tanggal) > hitung_hari(tanggalb) then begin
				writeln('Anda terlambat mengembalikan buku.');
				writeln('Anda terkena denda ', 2000 * (hitung_hari(tanggal) - hitung_hari(tanggalb)),'.');
			end else begin
				arraypeminjaman[i].status_pengembalian := 'sudah'; {update bahwa pengunjung sudah mengembalikan}
				//tabel_peminjaman[i][5] := 'sudah'; 
				inc(arraybuku[pos].jumlah_buku, 1); {menambah buku yang sudah dibalikkan pada data buku}
				
				{Menambahkan data ke history pengembalian}
				banyakpengembalian := length(arraypengembalian);
				SetLength(arraypengembalian, banyakpengembalian + 1);
				arraypengembalian[banyakpengembalian].username := nama_pengunjung;
				arraypengembalian[banyakpengembalian].id_buku := id;
				arraypengembalian[banyakpengembalian].tanggal_pengembalian := tanggal;
				
				writeln('Terima kasih sudah meminjam.');
				
				masukkan_array_buku(arraybuku, tabel_buku);
				masukkan_array_peminjaman(arraypeminjaman, tabel_peminjaman);
				masukkan_array_pengembalian(arraypengembalian, tabel_pengembalian);
			end;
		end;
	end;
	
	if not found then begin
		writeln('Data peminjaman tidak ditemukan.');
	end;
end;

procedure laporhilang(var hilang : textfile; var tabelhilang : tabel_data; nama_pengunjung : string);
{DESKRIPSI PROSEDUR}
{Prosedur untuk menambahkan data ke kehilangan.csv saat pengunjung yang sudah login melaporkan bukunnya yang hilang}

{KAMUS LOKAL}
var
	id : integer;
	judul, tanggal : string;
	arraylaporan : array_of_laporan;
	banyaklaporan : integer;
	
{ALGORITMA}
begin
	write('Masukkan id buku : ');
	readln(id);
	write('Masukkan judul buku : ');
	readln(judul);
	write('Masukkan tanggal pelaporan : ');
	readln(tanggal);
	
	{Masukkan tabel hasil parse ke dalam array of laporan}
	arraylaporan := buat_array_laporan(tabelhilang);
	
	{Tambahkan data ke kehilangan.csv}
	banyaklaporan := length(arraylaporan);
	setLength(arraylaporan, banyaklaporan + 1);
	arraylaporan[banyaklaporan].username := nama_pengunjung;
	arraylaporan[banyaklaporan].id_buku := id;
	arraylaporan[banyaklaporan].tanggal_laporan := tanggal;
	
	masukkan_array_laporan(arraylaporan, tabelhilang);
	
	writeln('Laporan berhasil diterima');
	
	save_data(hilang, tabelhilang);
end;

end.

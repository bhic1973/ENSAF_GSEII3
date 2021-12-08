### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 609aa3e6-5b23-44d3-99e1-6bab8fc5912f
begin
	import Pkg
	WORK_DIR = "/home/belkebir/Documents/ENSAF_doc/GSEII3/TIN/tp"
	cd(WORK_DIR)
	Pkg.activate(".")
end

# ╔═╡ cf108a13-50a9-408c-8969-b909cd38ff33
begin
	using PlutoUI, Images
	using Plots
end

# ╔═╡ 09a3361a-5533-11ec-2c13-a31bea2cce31
html"""
<style type="text/css">
.divcls {
	padding: 1% 5% 1% 5%;
	width: 100%;
	background-color: #333e;
}

.headercls {
	color: white;
	text-align: center;
	font-family: sans-serif;
}
</style>
<div class="divcls">
<h1 class="headercls"> TP de Traitement d'Image Numerique </h1>
<h3 class="headercls"> Seance 01 </h3>
<h2 class="headercls"> Reconstruction d'images RGB a partir de données brutes</h2>
<h5 class="headercls"> Préparé et encadré par: Pr. Hicham Belkebir</h5>
<h6 class="headercls"> Annee universitaire: 2021-2022</h6>
</div>
"""

# ╔═╡ 55077158-c65a-4a7d-80b4-d83f6301eb4c
md"""
__Pi Camera__
====
Please check this link for more details about how to use the raspberry pi camera module:

[Pi camera documentation](https://www.raspberrypi.com/documentation/accessories/camera.html)

[Libcamera website](https://libcamera.org/)

[Picamera Python module documentation](https://picamera.readthedocs.io/en/release-1.13/index.html)

"""

# ╔═╡ f4f963b1-641d-493b-9e1e-ec7b4ecacdc9
md"""
## Stilling raw image using the remote Raspberry Pi Camera: 
"""

# ╔═╡ 59a4b1d5-7758-442d-bab6-db8a56f5a98e
md"### 1. Tester la connexion avec la raspberry distante."

# ╔═╡ 91ee6fdd-0282-4105-8e6d-5aeb9b57d973
md"""
```julia
begin
	ruser = "pi"
	luser = "belkebir"
	rhost = "192.168.1.2"
	lhost = "192.168.1.4"
	PWD = pwd()
	RPWD = "/home/$ruser"
	r_fname = "data.txt"
	# script python pour tester la connexion avec la raspberry pi.
	remote_cmd = 
		\"\"\"
		printf \"The remote machine is: \$(uname -m)\n\";
		python -c 'print(\"hello world\")';
		python -c \"\"\" 
		import random as rnd;
		fd = open('data.txt','w')
		uarr = [rnd.randint(0,255) for _ in range(10)];
		for val in range(10):
			fd.write(f'{val}, ')
		fd.close();
		\"\"\";
		exit;
		\"\"\"
	# telechrger le fichier texte creer sure la raspberry pi et afficher son contenu dans le terminale
	rget_cmd = `scp -r $ruser\@$rhost\:$RPWD/$r_fname $luser\@$lhost\:$PWD\;cat\ $r_fname\;printf\ done.`
	with_terminal() do
		run(`ssh $ruser\@$rhost $remote_cmd`)
		run(rget_cmd)
	end;
end
```
"""

# ╔═╡ a84ee441-7564-4db8-b4bc-2d55657570dc
md"### 2. Capturing to a file"

# ╔═╡ 268e3c65-123d-49eb-825c-f7f91ec73dcc
md"""
```julia
# Capturing procedure on remote machine.
cap01 = "cap01.jpg"
r_capture = 
		\"\"\"
		printf \"Capturing image by using Python PiCamera module on remote machine\n\";
		python3 -c \"\"\" 
		from time import sleep
		from picamera import PiCamera

		with PiCamera() as remote_cam:
			remote_cam.resolution = (1024, 768)
			rem_cam.start_preview()
			# Camera warm-up time
			sleep(2)
			camera.capture('cap01.jpg')
		\"\"\";
		exit;
		\"\"\"
	# telechrger le fichier texte creer sure la raspberry pi et afficher son contenu dans le terminale
	rget_cmd1 = `scp -r $ruser\@$rhost\:$RPWD/$cap01 $luser\@$lhost\:$PWD\;printf\ done.`
	with_terminal() do
		run(`ssh $ruser\@$rhost $r_capture`)
		run(rget_cmd1)
	end;
end
```
"""

# ╔═╡ 09f80a03-6547-428e-bb94-b0c34469f2c9
md"""### 3. Loading and displaying the image in Pluto notebook
```julia
begin
	cap01 = load(cap01)
	# Displaying some properties of the loaded image
	with_terminal() do
		println("The size of the captured image is: $(size(cap01))")
		println("The type of data structure of the image is: $(typeof(cap01))")
		println("The pixel coding in the stilling image is: $(eltype(cap01))")
		println("The average brightness in the image is: $(Mean(cap01))")
		println("The standard deviation in the image is: $(Std(cap01))")
	
	# Mean function definition	
	function Mean(im::AbstractMatrix)::Float64
		im_size = eltype(im)<:RGB ? reduce(*,size(im);init=3) : reduce(*,size(im))
		return sum(channelview(im)[:])/im_size
	# Standard deviation function definition
	function Std(im::AbstractMatrix)::Float64
		im_size = eltype(im)<:RGB ? reduce(*,size(im);init=3) : reduce(*,size(im))
		return sqrt.(sum((channelview(im)[:]).^2 .- Mean(im)^2)/im_size)
end
```
"""

# ╔═╡ 83b69292-20b1-41fa-9e08-d570fa0f8c12
md"""
### 4. TODO
>__1. Define and execute a function that calculates and displays the histogram or the normalized, or accumulated one.__
>
>__2. Define and execute a function that performs histogram equalization.__
>
>__3. Define a function that displays every channel of the image with its equivalent color (Red channel with red maps, Green one with green maps, and so on).__
>
>__4. Define a function that calculates the amplitude and phase spectrum of an image and displays them.__ 
"""

# ╔═╡ 7e8a4576-eb19-4cc4-8d81-70bd7fd99a8c
md"""
### 5. HomeWork:

__1. By using this python script still an image in uncoded `YUV` mode.__
```python
import time
import picamera

with picamera.PiCamera() as camera:
    camera.resolution = (300, 300)
    camera.start_preview()
    time.sleep(2)
    camera.capture('image.data', 'yuv')
```
>The specific YUV format used is YUV420 (planar). This means that the Y (luminance) values occur first in the resulting data and have full resolution (one 1-byte Y value for each pixel in the image). The Y values are followed by the U (chrominance) values, and finally the V (chrominance) values. The UV values have one quarter the resolution of the Y components (4 1-byte Y values in a square for each 1-byte U and 1-byte V value). This is illustrated in the diagram below:


$(load("pics/yuv_mode.jpg"))

It is also important to note that when outputting to unencoded formats, the camera rounds the requested resolution. The horizontal resolution is rounded up to the nearest multiple of 32 pixels, while the vertical resolution is rounded up to the nearest multiple of 16 pixels. For example, if the requested resolution is 100x100, the capture will actually contain 128x112 pixels worth of data, but pixels beyond 100x100 will be uninitialized.

Given that the YUV420 format contains 1.5 bytes worth of data for each pixel (a 1-byte Y value for each pixel, and 1-byte U and V values for every 4 pixels), and taking into account the resolution rounding, the size of a 100x100 YUV capture will be:
```math
\begin{equation}
\begin{array}[b]{rl}
    128.0 & \text{100 rounded up to nearest multiple of 32} \\
    \times \quad 112.0 & \text{100 rounded up to nearest multiple of 16} \\
    \times \qquad 1.5 & \text{bytes of data per pixel in YUV420 format} \\
    \hline
    21504.0 & \text{bytes total}
\end{array}
\end{equation}
```
The first 14336 bytes of the data (128*112) will be Y values, the next 3584 bytes (128 \times 112 \div 4) will be U values, and the final 3584 bytes will be the V values.

#### TODO:
- write a Julia program that recovers the `RGB` data from the `YUV` mode and displays the RGB image.
"""

# ╔═╡ Cell order:
# ╟─09a3361a-5533-11ec-2c13-a31bea2cce31
# ╟─609aa3e6-5b23-44d3-99e1-6bab8fc5912f
# ╟─cf108a13-50a9-408c-8969-b909cd38ff33
# ╟─55077158-c65a-4a7d-80b4-d83f6301eb4c
# ╟─f4f963b1-641d-493b-9e1e-ec7b4ecacdc9
# ╟─59a4b1d5-7758-442d-bab6-db8a56f5a98e
# ╟─91ee6fdd-0282-4105-8e6d-5aeb9b57d973
# ╟─a84ee441-7564-4db8-b4bc-2d55657570dc
# ╟─268e3c65-123d-49eb-825c-f7f91ec73dcc
# ╟─09f80a03-6547-428e-bb94-b0c34469f2c9
# ╟─83b69292-20b1-41fa-9e08-d570fa0f8c12
# ╟─7e8a4576-eb19-4cc4-8d81-70bd7fd99a8c

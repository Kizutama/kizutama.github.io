document.addEventListener('DOMContentLoaded', () => {
    const gallery = document.querySelector('.machi_photo-gallery');
    const loadingElement = document.querySelector('.machi_loading');
    const jsonFilePath = '/assets/images.json';
    let currentImageIndex = 0;
    const imagesPerBatch = 10;
    let isLoading = false; // 防止重复加载

    function loadImages() {
        if (isLoading || loadingElement.style.display === 'none') return;

        isLoading = true; // 设置加载状态

        loadingElement.style.display = 'block'; // 显示加载提示

        fetch(jsonFilePath)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(imageUrls => {
                console.log('Loaded image URLs:', imageUrls); // 输出加载的图片 URL 列表
                let loadedCount = 0;

                for (let i = 0; i < imagesPerBatch; i++) {
                    if (currentImageIndex >= imageUrls.length) {
                        break; // 如果没有更多图片，停止加载
                    }

                    const img = document.createElement('img');
                    img.src = imageUrls[currentImageIndex];
                    img.className = 'machi_gallery-image';
                    gallery.appendChild(img);

                    console.log('Appending image:', imageUrls[currentImageIndex]); // 输出正在添加的图片 URL

                    currentImageIndex++;
                    loadedCount++;
                }

                if (currentImageIndex >= imageUrls.length) {
                    loadingElement.innerText = 'No more photos to load';
                    loadingElement.style.display = 'none'; // 隐藏加载提示
                } else {
                    loadingElement.style.display = 'none'; // 隐藏加载提示
                }

                isLoading = false; // 重置加载状态
            })
            .catch(error => {
                console.error('Error loading image URLs:', error);
                loadingElement.innerText = 'Failed to load photos';
                isLoading = false; // 重置加载状态
            });
    }

    window.addEventListener('scroll', () => {
        if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 500) {
            loadImages();
        }
    });

    loadImages(); // 页面加载时立即加载一些图片
});

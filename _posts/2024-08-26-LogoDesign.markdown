---
layout: post
title:  文字の喜怒哀楽 —— スタンプデザイン
date:   2024-08-22 00:49:11 +0900
categories: Stamp Design
---

「フォントは文字の感情を伝える」この理念を具象化したいため、漢字スタンプを作ってみました。

---



    
<div class="container">
    <div class="text-container">
        <span class="zeng-font-demo">曾</span>
    </div>
    <div class="controls-container">
        <div class="control-container">
            <label for="happiness-slider">喜:</label>
            <input type="range" id="happiness-slider" min="100" max="900" value="100">
            <span id="happiness-value">100</span>
        </div>
        <div class="control-container">
            <label for="anger-slider">怒:</label>
            <input type="range" id="anger-slider" min="100" max="900" value="100">
            <span id="anger-value">100</span>
        </div>
        <div class="control-container">
            <label for="grief-slider">哀:</label>
            <input type="range" id="grief-slider" min="100" max="900" value="100">
            <span id="grief-value">100</span>
        </div>
        <div class="control-container">
            <label for="joy-slider">楽:</label>
            <input type="range" id="joy-slider" min="100" max="900" value="100">
            <span id="joy-value">100</span>
        </div>
    </div>
</div>

<br>
<br>



<script>
const sliders = {
    happiness: document.getElementById('happiness-slider'),
    anger: document.getElementById('anger-slider'),
    grief: document.getElementById('grief-slider'),
    joy: document.getElementById('joy-slider')
};

const values = {
    happiness: document.getElementById('happiness-value'),
    anger: document.getElementById('anger-value'),
    grief: document.getElementById('grief-value'),
    joy: document.getElementById('joy-value')
};

const fontDemo = document.querySelector('.zeng-font-demo');
let activeSlider = null;

function calculatePercentage(value) {
    return ((value - 100) / 800 * 100).toFixed(2); // 保留两位小数
}

function updateSliders(event) {
    const currentSlider = event.target;
    activeSlider = currentSlider;

    // 计算每个滑动条的百分比
    let percentages = {};
    let totalPercentage = 0;

    for (let key in sliders) {
        let slider = sliders[key];
        percentages[key] = calculatePercentage(slider.value);
        totalPercentage += parseFloat(percentages[key]);
    }

    // 计算当前滑动条的百分比
    const activeKey = currentSlider.id.replace('-slider', '');
    const activePercentage = calculatePercentage(currentSlider.value);
    totalPercentage -= parseFloat(percentages[activeKey]);
    totalPercentage += parseFloat(activePercentage);

    // 如果总百分比超过100，则调整其他滑动条
    if (totalPercentage > 100) {
        let excess = totalPercentage - 100;

        // 创建待调整的滑动条数组
        let slidersToAdjust = Object.keys(sliders).filter(key => sliders[key] !== currentSlider);

        // 调整其他滑动条的值
        slidersToAdjust.forEach(key => {
            let slider = sliders[key];
            let currentValue = parseInt(slider.value);
            let currentPercentage = parseFloat(percentages[key]);
            if (currentPercentage > 0) {
                let reduction = (currentPercentage / (100 - activePercentage)) * excess;
                slider.value = Math.max(100, currentValue - ((reduction / 100) * 800));
                percentages[key] = calculatePercentage(slider.value);
            }
        });
    }

    // 更新百分比显示
    values.happiness.textContent = `${percentages.happiness}%`;
    values.anger.textContent = `${percentages.anger}%`;
    values.grief.textContent = `${percentages.grief}%`;
    values.joy.textContent = `${percentages.joy}%`;

    // 更新字体设置
    fontDemo.style.fontVariationSettings = 
        `"HAPY" ${sliders.happiness.value}, "ANGE" ${sliders.anger.value}, "GRIE" ${sliders.grief.value}, "JOOY" ${sliders.joy.value}`;
}

// 为滑动条添加事件监听器
for (let key in sliders) {
    sliders[key].addEventListener('input', updateSliders);
}

// 初始更新
updateSliders({ target: sliders.happiness }); // 用一个滑动条初始化

</script>

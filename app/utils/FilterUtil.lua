--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
cc.exports.FilterUtil = cc.exports.FilterUtil or  {};
FilterUtil.FILTERS = {

        -- custom
        -- {"CUSTOM", json.encode({frag = "Shaders/example_Flower.fsh",
        --                  center = {display.cx, display.cy},
        --                  resolution = {480, 320}})},
        CUSTOM_BLUR_ESPIA = {{"CUSTOM", "CUSTOM"},                        
                {json.encode({frag = "Shaders/example_Blur.fsh",
                shaderName = "blurShader",
                resolution = {480,320},
                blurRadius = 10,
                sampleNum = 5}),
                
                json.encode({frag = "Shaders/example_sepia.fsh",
                shaderName = "sepiaShader",})}},--自定义的褐色+模糊滤镜

        CUSTOM_OUTLINE = {"CUSTOM",
             json.encode({frag = "res/Shaders/example_outline.fsh",
              shaderName = "outlineShader",
              u_outlineColor = {249/255, 191/255, 56/255},
              u_radius = 0.001,
              u_threshold = 0.5, --线条大小
            })},--自定义的描边滤镜(黄)
        CUSTOM_TEST = {"TEST",
            json.encode({frag = "res/Shaders/test.fsh",
                shaderName = "outlineShader",
                u_outlineColor = {249/255, 191/255, 56/255},
                u_radius = 0.001,
                u_threshold = 0.5, --线条大小
            })},--自定义的描边滤镜(黄)     
            
        CUSTOM_OUTLINE_WHITE = {"CUSTOM",
            json.encode({frag = "res/Shaders/example_outline.fsh",
                shaderName = "outlineShader",
                u_outlineColor = {249/255, 255/255, 255/255},
                u_radius = 0.001,
                u_threshold = 0.5, --线条大小
            })},--自定义的描边滤镜（白）
        -- colors
        GRAY = {"GRAY",{0.2, 0.3, 0.5, 0.1}},--灰阶
        RGB = {"RGB",{1, 0.5, 0.3}},--变红（rgb的值需要是ps面板显示的值/100）
        HUE = {"HUE", {90}},--色相
        BRIGHTNESS = {"BRIGHTNESS", {0.3}},--高亮
        SATURATION = {"SATURATION", {0}},--饱和度
        CONTRAST = {"CONTRAST", {2}},--对比度
        EXPOSURE = {"EXPOSURE", {2}},--曝光
        GAMMA = {"GAMMA", {2}},--灰度
        HAZE = {"HAZE", {0.1, 0.2}},--朦胧化
        --{"SEPIA", {}},
        -- blurs
        GAUSSIAN_VBLUR = {"GAUSSIAN_VBLUR", {7}},--高斯模糊 纵向模糊
        GAUSSIAN_HBLUR = {"GAUSSIAN_HBLUR", {7}},--高斯模糊 横向模糊
        ZOOM_BLUR = {"ZOOM_BLUR", {4, 0.7, 0.7}},--镜头模糊
        MOTION_BLUR = {"MOTION_BLUR", {5, 135}},--动作模糊
        -- others
        SHARPEN = {"SHARPEN", {1, 1}},--锐化
        GRAY_GAUSSIAN = {{"GRAY", "GAUSSIAN_VBLUR", "GAUSSIAN_HBLUR"}, {nil, {10}, {10}}},--变灰且纵向高斯模糊
        BRIGHTNESS_CONTRAST = {{"BRIGHTNESS", "CONTRAST"}, {{0.1}, {4}}},--亮度和对比度同时调整
        HUE_SATURATION_BRIGHTNESS = {{"HUE", "SATURATION", "BRIGHTNESS"}, {{240}, {1.5}, {-0.4}}},--色相、饱和度、亮度

}
--需要添加滤镜的对象，滤镜名称（见FilterUtil.FILTERS的key），参数（若没有，则按照FilterUtil.FILTERS里的这个滤镜的默认值来设置）
--想要添加多个，请用addFilters
function FilterUtil:addFilter(target, filterName, param)    
    if GameGlobal.islowEnd then
        return
    end
    local __curFilter = FilterUtil.FILTERS[filterName]    

    local __filters, __params = unpack(__curFilter)
    if __params and #__params == 0 then
        __params = nil
    end
    if param ~= nil then
        __params = param;
    end
    if type(__filters) == "table" then
        local newFilter = filter.newFilters(__filters, __params)
        target:setFilters(newFilter);
    else
        local newFilter = filter.newFilter(__filters, __params)
        target:setFilter(newFilter);
    end    
end

--同时添加多个滤镜。格式如FilterUtil.FILTERS里的：HUE_SATURATION_BRIGHTNESS，即：
--filterTab={"HUE", "SATURATION", "BRIGHTNESS"}， paramTab = {{240}, {1.5}, {-0.4}}
function FilterUtil:addFilters(target, filterTab, paramTab)
    if GameGlobal.islowEnd then
        return
    end
    local newFilter = filter.newFilters(filterTab, paramTab)
    target:setFilters(newFilter);
end
function FilterUtil:clearFilters(target)
    if GameGlobal.islowEnd then
        return
    end
    target:clearFilter()
end

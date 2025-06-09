#!/bin/bash

# 修复 withOpacity 弃用警告的脚本
# 将 .withOpacity(value) 替换为 .withValues(alpha: value)

# 处理 ApeVoloBackgroundView
sed -i '' 's/\.withOpacity(\([^)]*\))/.withValues(alpha: \1)/g' lib/shared/components/apevolo_background/views/apevolo_background_view.dart

# 处理 MaterialBackgroundView  
sed -i '' 's/\.withOpacity(\([^)]*\))/.withValues(alpha: \1)/g' lib/shared/components/material_background/views/material_background_view.dart

echo "弃用警告修复完成！"

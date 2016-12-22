//
//  YTHeaderImageSettingVC.m
//  爱理不离
//
//  Created by ios on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTHeaderImageSettingVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTUserModel.h"

@interface YTHeaderImageSettingVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)NSData *imageData;
@property(nonatomic,strong)YTUserModel *userInfo;
@end

@implementation YTHeaderImageSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userInfo = [YTUserModel sharedYTUserModel];
    self.title = @"个人头像";
    self.view.backgroundColor = YTColor(239, 209, 211);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH)];
    self.headerImageView.image = self.headImg;
    self.headerImageView.userInteractionEnabled = YES;
    //添加手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    [self.headerImageView addGestureRecognizer:pinch];
    pinch.delegate = self;
    [self.view addSubview:self.headerImageView];
    
    //添加pan手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    
    [self.headerImageView addGestureRecognizer:pan];
    
    //添加旋转手势
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotate:)];
    rotate.delegate = self;
    [self.headerImageView addGestureRecognizer:rotate];
  
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_more_os7" highIcon:@"navigationbar_more_os7" target:self action:@selector(chooseMenuButtonTapped)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
}


#pragma mark  - custom
//弹出图片选择
- (void)chooseMenuButtonTapped{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //打开相机
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *photoAblum = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //打开相册
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    [actionSheet addAction:cancel];
    [actionSheet addAction:camera];
    [actionSheet addAction:photoAblum];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)leftButtonTapped{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//监听捏合手势
- (void)pinch:(UIPinchGestureRecognizer *)pinch{
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    NSLog(@"%f",pinch.scale);
    pinch.scale = 1; // 这个真的很重要!!!!!
    
}
//监听拖拽手势
- (void)pan:(UIPanGestureRecognizer *)pan{
    // 1.在view上面挪动的距离
    CGPoint translation = [pan translationInView:pan.view];
    CGPoint center = pan.view.center;
    center.x += translation.x;
    center.y += translation.y;
    pan.view.center = center;
    // 2.清空移动的距离
    [pan setTranslation:CGPointZero inView:pan.view];
}
//监听旋转手势
- (void)rotate:(UIRotationGestureRecognizer *)rotate{
    rotate.view.transform = CGAffineTransformRotate(rotate.view.transform, rotate.rotation);
    rotate.rotation = 0; // 这个很重要!!!!!
}

#pragma mark - 手势识别器的代理方法

/**
 *  是否允许多个手势识别器同时有效
 *  Simultaneously : 同时地
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
     return YES;
}

#pragma mark - imagePickerControllerdelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *headerImage = info[UIImagePickerControllerEditedImage];
    
    
    self.headerImageView.image = headerImage;
    self.imageData = UIImagePNGRepresentation(headerImage);
    
    
    //上传头像图片
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer.timeoutInterval = 10.0f;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manger POST:[kDominURL URLStringWithStr:@"/user/upload_image.do"] parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:_imageData name:@"imgFile" fileName:fileName mimeType:@"image/jpeg"];
        
  
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"---------上传头像返回%@",dic);
        
        if ([[dic objectForKey:@"state"] isEqualToString:@"SUCCESS"]) {
            //调用更新个人信息接口
            //更新信息请求
            NSDictionary *param;
            param = @{@"avatar":[dic objectForKey:@"url"]};
            
            AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
            manger.requestSerializer = [AFHTTPRequestSerializer serializer];
            manger.responseSerializer = [AFHTTPResponseSerializer serializer];
            manger.requestSerializer.timeoutInterval = 10.0f;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [manger POST:[kDominURL URLStringWithStr:@"/user/user_info.update"] parameters:@{@"object":str} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSLog(@"-----返回%@",dic);
                if ([[dic objectForKey:@"code"] intValue] == 0) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"更新成功" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                        
                        //上传成功
                        self.userInfo.avatar = [dic objectForKey:@"url"];
                        //将文件写入内存
                        NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
                        // 归档
                        [NSKeyedArchiver archiveRootObject: self.userInfo toFile:file];
                        
                        //反向传值
                        [self.delegate imageBackToMeVC:self image:headerImage];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"网络故障,请重新提交" actionTitle:@"好" andStyle:1] animated:YES completion:nil];
            }];


          

        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@",error);
        
        
        NSLog(@"上传失败");
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy
- (NSData *)imageData{
    if (_imageData == nil) {
        _imageData = [NSData data];
    }
    return _imageData;
}

@end

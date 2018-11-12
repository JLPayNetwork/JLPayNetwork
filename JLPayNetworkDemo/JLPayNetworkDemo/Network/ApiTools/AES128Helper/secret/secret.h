#ifndef AFX_SECRET_H
#define AFX_SECRET_H

#ifdef __cplusplus
extern "C" {
#endif

/******************************************************************************************
** Descriptions:       数据加密
** Parameters:         pKey  密钥
**                     keylen  密钥长度
**                     pData  待加密数据
**                     datalen  待加密数据长度
**                     pOut  加密后数据
** Returned value:     >0  加密成功,返回加密后数据长度
**                     <=0 加密失败
** Created By:         syh 20180726
** Remarks:            密钥长度固定16个字节，加密数据长度不限
*******************************************************************************************/
extern int jlencrypt(unsigned char *pKey, int keylen, unsigned char *pData, int datalen, unsigned char *pOut);

/******************************************************************************************
** Descriptions:       数据解密
** Parameters:         pKey  密钥
**                     keylen  密钥长度
**                     pData  待解密数据
**                     datalen  待解密数据长度
**                     pOut  解密后数据
** Returned value:     >0  解密成功,返回解密后数据长度
**                     <=0 解密失败
** Created By:         syh 20180726
** Remarks:            密钥长度固定16个字节，解密数据需为16倍数
*******************************************************************************************/
extern int jldecrypt(unsigned char *pKey, int keylen, unsigned char *pData, int datalen, unsigned char *pOut);

#ifdef __cplusplus
}
#endif

#endif

/*
 * Copyright (c) 2019 TAOS Data, Inc. <jhtao@taosdata.com>
 *
 * This program is free software: you can use, redistribute, and/or modify
 * it under the terms of the GNU Affero General Public License, version 3
 * or later ("AGPL"), as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "executor.h"
#include "tq.h"
#include "executorimpl.h"
#include "planner.h"

static int32_t doSetStreamBlock(SOperatorInfo* pOperator, void* input, char* id) {
  ASSERT(pOperator != NULL);
  if (pOperator->operatorType != OP_StreamScan) {
    if (pOperator->numOfDownstream == 0) {
      qError("failed to find stream scan operator to set the input data block, %s" PRIx64, id);
      return TSDB_CODE_QRY_APP_ERROR;
    }

    if (pOperator->numOfDownstream > 1) {  // not handle this in join query
      qError("join not supported for stream block scan, %s" PRIx64, id);
      return TSDB_CODE_QRY_APP_ERROR;
    }

    return doSetStreamBlock(pOperator->pDownstream[0], input, id);
  } else {
    SStreamBlockScanInfo* pInfo = pOperator->info;
    tqReadHandleSetMsg(pInfo->readerHandle, input, 0);
    return TSDB_CODE_SUCCESS;
  }
}

int32_t qSetStreamInput(qTaskInfo_t tinfo, const void* input) {
  if (tinfo == NULL) {
    return TSDB_CODE_QRY_APP_ERROR;
  }

  if (input == NULL) {
    return TSDB_CODE_SUCCESS;
  }

  SExecTaskInfo* pTaskInfo = (SExecTaskInfo*) tinfo;

  int32_t code = doSetStreamBlock(pTaskInfo->pRoot, (void*) input, GET_TASKID(pTaskInfo));
  if (code != TSDB_CODE_SUCCESS) {
    qError("%s failed to set the stream block data", GET_TASKID(pTaskInfo));
  } else {
    qDebug("%s set the stream block successfully", GET_TASKID(pTaskInfo));
  }

  return code;
}

qTaskInfo_t qCreateStreamExecTaskInfo(void* msg, void* streamReadHandle) {
  if (msg == NULL || streamReadHandle == NULL) {
    return NULL;
  }

  // print those info into log
#if 0
  pMsg->sId = pMsg->sId;
  pMsg->queryId = pMsg->queryId;
  pMsg->taskId = pMsg->taskId;
  pMsg->contentLen = pMsg->contentLen;
#endif

  struct SSubplan* plan = NULL;
  int32_t          code = qStringToSubplan(msg, &plan);
  if (code != TSDB_CODE_SUCCESS) {
    terrno = code;
    return NULL;
  }

  qTaskInfo_t pTaskInfo = NULL;
  code = qCreateExecTask(streamReadHandle, 0, 0, plan, &pTaskInfo, NULL);
  if (code != TSDB_CODE_SUCCESS) {
    // TODO: destroy SSubplan & pTaskInfo
    terrno = code;
    return NULL;
  }

  return pTaskInfo;
}

int32_t qUpdateTQualifiedTableId(qTaskInfo_t tinfo, SArray* tableIdList, bool isAdd) {
  SExecTaskInfo* pTaskInfo = (SExecTaskInfo* )tinfo;

  // traverse to the streamscan node to add this table id
  SOperatorInfo* pInfo = pTaskInfo->pRoot;
  while(pInfo->operatorType != OP_StreamScan) {
    pInfo = pInfo->pDownstream[0];
  }

  SStreamBlockScanInfo* pScanInfo = pInfo->info;
  if (isAdd) {
    int32_t code = tqReadHandleSetTbUidList(pScanInfo->readerHandle, tableIdList);
    if (code != TSDB_CODE_SUCCESS) {
      return code;
    }
  } else {
    assert(0);
  }

  return TSDB_CODE_SUCCESS;
}
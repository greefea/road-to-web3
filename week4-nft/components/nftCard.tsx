import { useCopyToClipboard } from 'react-use'

export const NFTCard = ({ nft }) => {
    const [clipboard, copyToClipboard] = useCopyToClipboard()

    return (
        <div className="w-1/4 flex flex-col ">
        <div className="rounded-md">
            <img className="object-cover h-128 w-full rounded-t-md" src={nft.media[0].gateway} ></img>
        </div>
        <div className="flex flex-col y-gap-2 px-2 py-3 bg-slate-100 rounded-b-md h-110 ">
            <div className="">
                <h2 className="text-xl text-gray-800">{nft.title}</h2>
                <p className="text-gray-600">Id: {nft.id.tokenId.replace('0x0+', '')}</p>
                <span className="text-gray-600" >
                {nft.contract.address}
                 <img src="https://cdn-icons-png.flaticon.com/512/1621/1621635.png" alt="copy to clipboard" width="16" height="16" align="left" 
                    onClick={
                        () =>copyToClipboard(`${nft.contract.address}`) 
                    }/> 
                 
                </span>
            </div>

            <div className="flex-grow mt-2">
                <p className="text-gray-600">{nft.description}</p>
            </div>
        </div>

    </div>
    )
}